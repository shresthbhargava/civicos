package com.civicos.platform.domain.news.api;

import com.civicos.platform.common.response.ApiResponse;
import com.civicos.platform.domain.news.application.DailyEditionService;
import com.civicos.platform.domain.news.application.NewsFetchService;
import com.civicos.platform.domain.news.domain.DailyEdition;
import com.civicos.platform.domain.news.domain.DailyEditionRepository;
import com.civicos.platform.domain.news.domain.NewsArticle;
import com.civicos.platform.domain.news.domain.NewsArticleRepository;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.servlet.http.HttpServletRequest;
import lombok.RequiredArgsConstructor;
import org.springframework.context.annotation.Lazy;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Tag(name = "News", description = "Real-time civic news from India")
@RestController
@RequestMapping("/api/v1/news")
@RequiredArgsConstructor
public class NewsController {

    private final NewsArticleRepository newsArticleRepository;
    private final DailyEditionRepository dailyEditionRepository;

    @Lazy
    private final NewsFetchService newsFetchService;

    @Lazy
    private final DailyEditionService dailyEditionService;

    @Operation(summary = "Manually trigger news fetch")
    @PostMapping("/fetch")
    public ResponseEntity<ApiResponse<String>> fetchNow(HttpServletRequest request) {
        newsFetchService.fetchLatestNews();
        return ResponseEntity.ok(ApiResponse.success("News fetch triggered", request));
    }

    @Operation(summary = "Get latest civic news")
    @GetMapping("/latest")
    public ResponseEntity<ApiResponse<List<NewsArticle>>> getLatest(
            HttpServletRequest request) {
        List<NewsArticle> articles = newsArticleRepository
                .findTop10ByOrderByPublishedAtDesc();
        return ResponseEntity.ok(ApiResponse.success(articles, request));
    }

    @Operation(summary = "Get today's edition")
    @GetMapping("/edition/today")
    public ResponseEntity<ApiResponse<DailyEdition>> getTodaysEdition(
            HttpServletRequest request) {
        var edition = dailyEditionRepository.findTopByOrderByEditionDateDesc();
        return edition.map(e -> ResponseEntity.ok(ApiResponse.success(e, request)))
                .orElse(ResponseEntity.ok(ApiResponse.success(null, request)));
    }

    @Operation(summary = "Manually generate today's edition")
    @PostMapping("/edition/generate")
    public ResponseEntity<ApiResponse<String>> generateEdition(
            HttpServletRequest request) {
        dailyEditionService.generateDailyEdition();
        return ResponseEntity.ok(ApiResponse.success("Edition generation triggered", request));
    }
}