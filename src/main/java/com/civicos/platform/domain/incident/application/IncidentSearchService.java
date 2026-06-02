package com.civicos.platform.domain.incident.application;

import com.civicos.platform.domain.department.application.AccountabilityNode;
import com.civicos.platform.domain.department.application.AccountabilityService;
import com.civicos.platform.domain.incident.domain.IncidentCategoryRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.civicos.platform.domain.official.application.OfficialService;
import com.civicos.platform.domain.official.application.OfficialResponse;


import java.sql.SQLException;
import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;

@Slf4j
@Service
@RequiredArgsConstructor
public class IncidentSearchService {

    private final IncidentCategoryRepository incidentCategoryRepository;
    private final AccountabilityService accountabilityService;
    private final OfficialService officialService;

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
    }

    @Transactional(readOnly = true)
    public List<IncidentCategoryResponse> getAllCategories() {

        return incidentCategoryRepository.findAll()
                .stream()
                .map(IncidentCategoryResponse::from)
                .toList();
    }

    @Transactional(readOnly = true)
    public IncidentSearchResponse search(
            String rawQuery,
            LocationContext location
    ) {

        List<String> queryTokens = tokenize(rawQuery);

        log.info(
                "Incident search query='{}' tokens={} state={} district={}",
                rawQuery,
                queryTokens,
                location.getStateCode(),
                location.getDistrictCode()
        );

        String[] tokenArray = queryTokens.toArray(new String[0]);

        List<Object[]> rows =
                incidentCategoryRepository.searchByKeywordsAndLocation(
                        tokenArray,
                        location.getStateCode(),
                        location.getDistrictCode()
                );

        log.debug("Query returned {} rows", rows.size());

        List<IncidentSearchResponse.IncidentMatch> matches =
                rows.stream()
                        .map(row -> buildMatchFromRow(row, queryTokens))
                        .collect(Collectors.toList());

        return IncidentSearchResponse.builder()
                .query(rawQuery)
                .matchType("KEYWORD")
                .matches(matches)
                .build();
    }

    private IncidentSearchResponse.IncidentMatch buildMatchFromRow(
            Object[] row,
            List<String> queryTokens
    ) {

        log.debug("ROW = {}", Arrays.toString(row));

        Long categoryId =
                ((Number) row[Columns.CATEGORY_ID]).longValue();

        String categoryName =
                (String) row[Columns.CATEGORY_NAME];

        String categoryCode =
                (String) row[Columns.CATEGORY_CODE];

        String[] keywords =
                extractStringArray(row[Columns.KEYWORDS]);

        String[] citizenActions =
                extractStringArray(row[Columns.CITIZEN_ACTIONS]);

        Long deptId =
                ((Number) row[Columns.DEPT_ID]).longValue();

        String deptCode =
                (String) row[Columns.DEPT_CODE];

        String deptName =
                (String) row[Columns.DEPT_NAME];

        String deptJurisdictionLevel =
                String.valueOf(row[Columns.DEPT_JURISDICTION]);

        List<String> matchedKeywords = Arrays.stream(keywords)
                .filter(keyword ->
                        queryTokens.stream()
                                .anyMatch(token ->
                                        keyword.toLowerCase().contains(token)
                                )
                )
                .collect(Collectors.toList());

        List<AccountabilityNode> chain =
                accountabilityService.getChain(deptId);
        List<OfficialResponse> officials =
                officialService.getCurrentOfficials(deptId);

        IncidentSearchResponse.DepartmentSummary deptSummary =
                IncidentSearchResponse.DepartmentSummary.builder()
                        .id(deptId)
                        .code(deptCode)
                        .name(deptName)
                        .jurisdictionLevel(deptJurisdictionLevel)
                        .currentOfficials(officials)
                        .build();

        return IncidentSearchResponse.IncidentMatch.builder()
                .categoryId(categoryId)
                .categoryName(categoryName)
                .categoryCode(categoryCode)
                .matchedKeywords(matchedKeywords)
                .responsibleDepartment(deptSummary)
                .accountabilityChain(chain)
                .citizenActions(Arrays.asList(citizenActions))
                .build();
    }

    private String[] extractStringArray(Object rawValue) {

        if (rawValue == null) {
            return new String[0];
        }

        // PostgreSQL/Hibernate already returned String[]
        if (rawValue instanceof String[] stringArray) {
            return stringArray;
        }

        // fallback for SQL Array
        try {
            if (rawValue instanceof java.sql.Array sqlArray) {
                return (String[]) sqlArray.getArray();
            }
        } catch (SQLException e) {
            log.warn("Failed to extract array value", e);
        }

        return new String[0];
    }

    private List<String> tokenize(String query) {

        return Arrays.stream(
                        query.toLowerCase()
                                .trim()
                                .split("\\s+")
                )
                .filter(token -> token.length() > 2)
                .distinct()
                .collect(Collectors.toList());
    }
}