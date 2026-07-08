package com.civicos.platform.domain.incident.application;

import com.civicos.platform.domain.department.application.AccountabilityNode;
import com.civicos.platform.domain.department.application.AccountabilityService;
import com.civicos.platform.domain.incident.domain.IncidentCategory;
import com.civicos.platform.domain.incident.domain.IncidentCategoryRepository;
import com.civicos.platform.common.ai.EmbeddingService;
import com.civicos.platform.domain.news.application.DailyEditionService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.civicos.platform.domain.official.application.OfficialService;
import com.civicos.platform.domain.official.application.OfficialResponse;
import com.civicos.platform.domain.act.domain.ActRepository;
import com.civicos.platform.domain.act.application.ActResponse;
import org.springframework.cache.annotation.Cacheable;
import com.civicos.platform.common.ai.LlmClassificationService;

import java.sql.SQLException;
import java.util.Arrays;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;
import com.civicos.platform.common.kafka.SearchEventProducer;
import com.civicos.platform.common.kafka.SearchEvent;
import java.time.Instant;

@Slf4j
@Service
@RequiredArgsConstructor
public class IncidentSearchService {

    private final IncidentCategoryRepository incidentCategoryRepository;
    private final AccountabilityService accountabilityService;
    private final OfficialService officialService;
    private final ActRepository actRepository;
    private final EmbeddingService embeddingService;
    private final SearchEventProducer searchEventProducer;
    private final DailyEditionService dailyEditionService;
    private final LlmClassificationService llmClassificationService;
    /**
     * Column indexes from native SQL query.
     */
    private interface Columns {

        // incident_categories table
        int CATEGORY_ID = 0;
        int CATEGORY_NAME = 1;
        int CATEGORY_CODE = 2;
        int DESCRIPTION = 3;
        int KEYWORDS = 4;
        int CITIZEN_ACTIONS = 5;
        int CREATED_AT = 6;
        int UPDATED_AT = 7;

        // resolved department fields from SQL aliases
        int DEPT_ID = 8;
        int DEPT_CODE = 9;
        int DEPT_NAME = 10;
        int DEPT_JURISDICTION = 11;
        int DEPT_COMPLAINT_URL = 12;
        int DEPT_WEBSITE_URL = 13;
    }

    @Transactional(readOnly = true)
    public List<IncidentCategoryResponse> getAllCategories() {
        return incidentCategoryRepository.findAll()
                .stream()
                .map(IncidentCategoryResponse::from)
                .toList();
    }

    @Transactional(readOnly = true)
    @Cacheable(value = "search-results", key = "#rawQuery + '-' + #location.stateCode + '-' + #location.districtCode")
    public IncidentSearchResponse search(
            String rawQuery,
            LocationContext location
    ) {
        List<String> queryTokens = tokenize(rawQuery);

        log.info("Incident search query='{}' tokens={} state={} district={}",
                rawQuery, queryTokens,
                location.getStateCode(),
                location.getDistrictCode());

        String[] tokenArray = queryTokens.toArray(new String[0]);

        List<Object[]> rows = incidentCategoryRepository.searchByKeywordsAndLocation(
                tokenArray,
                location.getStateCode(),
                location.getDistrictCode()
        );

        log.debug("Keyword search returned {} rows", rows.size());

        if (rows.isEmpty()) {
            log.info("No keyword results — falling back to semantic search");
            rows = semanticSearch(rawQuery, location.getStateCode());
            log.debug("Semantic search returned {} rows", rows.size());
        }

        if (rows.isEmpty()) {
            log.info("No semantic results — falling back to LLM classification");
            rows = llmFallback(rawQuery, location.getStateCode());
            log.debug("LLM fallback returned {} rows", rows.size());
        }

        List<IncidentSearchResponse.IncidentMatch> matches =
                rows.stream()
                        .map(row -> buildMatchFromRow(row, queryTokens))
                        .collect(Collectors.toList());

        IncidentSearchResponse response = IncidentSearchResponse.builder()
                .query(rawQuery)
                .matchType(rows.isEmpty() ? "NO_MATCH" : "KEYWORD")
                .matches(matches)
                .build();

        searchEventProducer.publishSearchEvent(SearchEvent.builder()
                .query(rawQuery)
                .stateCode(location.getStateCode())
                .districtCode(location.getDistrictCode())
                .matchType(response.getMatchType())
                .matchCount(matches.size())
                .topCategory(matches.isEmpty() ? null : matches.get(0).getCategoryCode())
                .timestamp(Instant.now())
                .build());

        return response;
    }

    private List<Object[]> semanticSearch(String query, String stateCode) {
        try {
            String embedding = embeddingService.getEmbedding(query);
            return incidentCategoryRepository.searchByEmbedding(embedding, stateCode, 0.80);
        } catch (Exception e) {
            log.warn("Semantic search failed: {}", e.getMessage());
            return List.of();
        }
    }

    private IncidentSearchResponse.IncidentMatch buildMatchFromRow(
            Object[] row,
            List<String> queryTokens
    ) {
        Long categoryId = ((Number) row[Columns.CATEGORY_ID]).longValue();
        String categoryName = (String) row[Columns.CATEGORY_NAME];
        String categoryCode = (String) row[Columns.CATEGORY_CODE];
        String[] keywords = extractStringArray(row[Columns.KEYWORDS]);
        String[] citizenActions = extractStringArray(row[Columns.CITIZEN_ACTIONS]);
        Long deptId = ((Number) row[Columns.DEPT_ID]).longValue();
        String deptCode = (String) row[Columns.DEPT_CODE];
        String deptName = (String) row[Columns.DEPT_NAME];
        String deptJurisdictionLevel = String.valueOf(row[Columns.DEPT_JURISDICTION]);
        String deptComplaintUrl = row.length > Columns.DEPT_COMPLAINT_URL ? (String) row[Columns.DEPT_COMPLAINT_URL] : null;
        String deptWebsiteUrl = row.length > Columns.DEPT_WEBSITE_URL ? (String) row[Columns.DEPT_WEBSITE_URL] : null;

        List<String> matchedKeywords = Arrays.stream(keywords)
                .filter(keyword ->
                        queryTokens.stream()
                                .anyMatch(token -> keyword.toLowerCase().contains(token))
                )
                .collect(Collectors.toList());

        List<AccountabilityNode> chain = List.of();
        try {
            chain = accountabilityService.getChain(deptId);
        } catch (Exception e) {
            log.warn("Failed to fetch accountability chain for deptId={}: {}", deptId, e.getMessage());
        }

        List<OfficialResponse> officials = List.of();
        try {
            officials = officialService.getCurrentOfficials(deptId);
        } catch (Exception e) {
            log.warn("Failed to fetch officials for deptId={}: {}", deptId, e.getMessage());
        }

        IncidentSearchResponse.DepartmentSummary deptSummary =
                IncidentSearchResponse.DepartmentSummary.builder()
                        .id(deptId)
                        .code(deptCode)
                        .name(deptName)
                        .jurisdictionLevel(deptJurisdictionLevel)
                        .complaintPortalUrl(deptComplaintUrl)
                        .websiteUrl(deptWebsiteUrl)
                        .currentOfficials(officials)
                        .build();

        List<ActResponse> relevantActs = List.of();
        try {
            var acts = actRepository.findByCategoryId(categoryId);
            if (acts != null) {
                relevantActs = acts.stream()
                        .map(ActResponse::from)
                        .collect(Collectors.toList());
            }
        } catch (Exception e) {
            log.warn("Failed to fetch acts for categoryId={}: {}", categoryId, e.getMessage());
        }

        return IncidentSearchResponse.IncidentMatch.builder()
                .categoryId(categoryId)
                .categoryName(categoryName)
                .categoryCode(categoryCode)
                .matchedKeywords(matchedKeywords)
                .responsibleDepartment(deptSummary)
                .accountabilityChain(chain)
                .citizenActions(Arrays.asList(citizenActions))
                .relevantActs(relevantActs)
                .build();
    }

    private String[] extractStringArray(Object rawValue) {
        if (rawValue == null) return new String[0];
        if (rawValue instanceof String[] stringArray) return stringArray;
        try {
            if (rawValue instanceof java.sql.Array sqlArray) {
                return (String[]) sqlArray.getArray();
            }
        } catch (SQLException e) {
            log.warn("Failed to extract array value", e);
        }
        return new String[0];
    }
    private List<Object[]> llmFallback(String query, String stateCode) {
        try {
            Optional<IncidentCategory> categoryOpt = llmClassificationService.classify(query, stateCode);
            if (categoryOpt.isEmpty()) return List.of();

            IncidentCategory category = categoryOpt.get();
            log.info("LLM classified '{}' as category {} [{}]", query, category.getName(), category.getCode());

            // Re-run keyword search with category's own keywords to get the full joined row
            String[] keywords = category.getKeywords() != null ? category.getKeywords() : new String[]{category.getName()};
            return incidentCategoryRepository.searchByKeywordsAndLocation(keywords, stateCode, null);

        } catch (Exception e) {
            log.warn("LLM fallback failed: {}", e.getMessage());
            return List.of();
        }
    }
    private List<String> tokenize(String query) {
        return Arrays.stream(query.toLowerCase().trim().split("\\s+"))
                .filter(token -> token.length() > 2)
                .distinct()
                .collect(Collectors.toList());
    }
}
