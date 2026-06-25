package com.civicos.platform.domain.news.application;

import com.civicos.platform.domain.incident.application.IncidentSearchResponse;
import com.civicos.platform.domain.incident.application.IncidentSearchService;
import com.civicos.platform.domain.incident.application.LocationContext;
import com.civicos.platform.domain.news.domain.DailyEdition;
import com.civicos.platform.domain.news.domain.DailyEditionRepository;
import com.civicos.platform.domain.news.domain.NewsArticle;
import com.civicos.platform.domain.news.domain.NewsArticleRepository;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Lazy;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.*;

@Slf4j
@Service
public class DailyEditionService {

    private final NewsArticleRepository newsArticleRepository;
    private final DailyEditionRepository dailyEditionRepository;
    private final IncidentSearchService incidentSearchService;

    @Autowired
    public DailyEditionService(
            NewsArticleRepository newsArticleRepository,
            DailyEditionRepository dailyEditionRepository,
            @Lazy IncidentSearchService incidentSearchService) {
        this.newsArticleRepository = newsArticleRepository;
        this.dailyEditionRepository = dailyEditionRepository;
        this.incidentSearchService = incidentSearchService;
    }

    @Scheduled(cron = "0 0 6 * * *")
    public void generateDailyEdition() {
        generateDailyEdition(false);
    }

    public void generateDailyEdition(boolean force) {
        LocalDate today = LocalDate.now();
        log.info("Generating daily edition for {} (force={})", today, force);

        var existingOpt = dailyEditionRepository.findByEditionDate(today);
        if (existingOpt.isPresent() && !force) {
            log.info("Daily edition for {} already exists", today);
            return;
        }

        List<NewsArticle> articles = newsArticleRepository
                .findTop10ByOrderByPublishedAtDesc();

        if (articles.isEmpty()) {
            log.warn("No articles available for daily edition");
            return;
        }

        List<Map<String, Object>> stories = new ArrayList<>();

        for (NewsArticle article : articles.subList(0, Math.min(5, articles.size()))) {
            Map<String, Object> story = new LinkedHashMap<>();
            story.put("title", article.getTitle());
            story.put("description", article.getDescription());
            story.put("sourceName", article.getSourceName());
            story.put("sourceUrl", article.getSourceUrl());
            story.put("publishedAt", article.getPublishedAt());

            try {
                String searchQuery = extractSearchQuery(article.getTitle());
                IncidentSearchResponse searchResult = incidentSearchService
                        .search(searchQuery, LocationContext.empty());

                if (!searchResult.getMatches().isEmpty()) {
                    var match = searchResult.getMatches().get(0);
                    story.put("accountableDepartment",
                            match.getResponsibleDepartment().getName());
                    story.put("categoryName", match.getCategoryName());
                    story.put("citizenActions", match.getCitizenActions());
                }
            } catch (Exception e) {
                log.warn("Could not find accountability for: {} - {}",
                        article.getTitle(), e.getMessage(), e);
            }

            stories.add(story);
        }

        DailyEdition edition = existingOpt.orElseGet(DailyEdition::new);
        edition.setEditionDate(today);
        edition.setHeadline(articles.get(0).getTitle().toUpperCase());
        edition.setStories(stories);
        edition.setGeneratedAt(LocalDateTime.now());

        dailyEditionRepository.save(edition);
        log.info("Daily edition generated with {} stories", stories.size());
    }

    private String extractSearchQuery(String title) {
        String[] keywords = {"nta", "exam", "water", "electricity", "food", "health",
                "hospital", "school", "road", "corruption", "audit", "rti",
                "ministry", "department", "government", "official"};

        String titleLower = title.toLowerCase();
        for (String keyword : keywords) {
            if (titleLower.contains(keyword)) {
                return keyword;
            }
        }
        return title.split(" ")[0];
    }
}