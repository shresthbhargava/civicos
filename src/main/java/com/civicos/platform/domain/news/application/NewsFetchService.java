package com.civicos.platform.domain.news.application;

import com.civicos.platform.domain.news.domain.NewsArticle;
import com.civicos.platform.domain.news.domain.NewsArticleRepository;
import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;

import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;

@Slf4j
@Service
@RequiredArgsConstructor
public class NewsFetchService {

    private final NewsArticleRepository newsArticleRepository;
    private final ObjectMapper objectMapper;

    private final NewsFetchService newsFetchService;
    @Value("${newsdata.api-key}")
    private String apiKey;

    private final HttpClient httpClient = HttpClient.newHttpClient();

    @Scheduled(fixedDelay = 21600000) // Every 6 hours
    public void fetchLatestNews() {
        log.info("Fetching latest civic news from NewsData.io");
        try {
            String url = "https://newsdata.io/api/1/news?" +
                    "apikey=" + apiKey +
                    "&country=in" +
                    "&language=en" +
                    "&q=government+ministry+accountability+RTI+audit" +
                    "&category=politics";

            HttpRequest request = HttpRequest.newBuilder()
                    .uri(URI.create(url))
                    .GET()
                    .build();

            HttpResponse<String> response = httpClient.send(
                    request, HttpResponse.BodyHandlers.ofString()
            );

            log.debug("NewsData API response: {}", response.body().substring(0, Math.min(500, response.body().length())));

            NewsDataResponse newsResponse = objectMapper.readValue(
                    response.body(), NewsDataResponse.class
            );

            if (newsResponse.getResults() != null) {
                int saved = 0;
                for (NewsDataResponse.NewsDataArticle article : newsResponse.getResults()) {
                    if (newsArticleRepository.findByArticleId(article.getArticleId()).isEmpty()) {
                        NewsArticle entity = mapToEntity(article);
                        newsArticleRepository.save(entity);
                        saved++;
                    }
                }
                log.info("Saved {} new articles", saved);
            }
        } catch (Exception e) {
            log.error("Failed to fetch news: {}", e.getMessage());
        }
    }

    private NewsArticle mapToEntity(NewsDataResponse.NewsDataArticle article) {
        return NewsArticle.builder()
                .articleId(article.getArticleId())
                .title(article.getTitle())
                .description(article.getDescription())
                .content(article.getContent())
                .sourceName(article.getSourceName())
                .sourceUrl(article.getLink())
                .imageUrl(article.getImageUrl())
                .category(article.getCategory() != null && !article.getCategory().isEmpty()
                        ? article.getCategory().get(0) : "general")
                .language(article.getLanguage())
                .publishedAt(parseDate(article.getPubDate()))
                .tags(article.getKeywords() != null
                        ? article.getKeywords().toArray(new String[0]) : new String[0])
                .createdAt(LocalDateTime.now())
                .build();
    }

    private LocalDateTime parseDate(String dateStr) {
        try {
            return LocalDateTime.parse(dateStr,
                    DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"));
        } catch (Exception e) {
            return LocalDateTime.now();
        }
    }
}