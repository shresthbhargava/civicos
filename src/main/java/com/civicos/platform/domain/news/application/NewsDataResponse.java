package com.civicos.platform.domain.news.application;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.Data;

import java.util.List;

@Data
public class NewsDataResponse {
    private String status;
    private Integer totalResults;
    private List<NewsDataArticle> results;
    private String nextPage;

    @Data
    public static class NewsDataArticle {
        @JsonProperty("article_id")
        private String articleId;
        private String title;
        private String description;
        private String content;
        private String link;
        @JsonProperty("source_name")
        private String sourceName;
        @JsonProperty("image_url")
        private String imageUrl;
        @JsonProperty("pubDate")
        private String pubDate;
        private List<String> category;
        private List<String> country;
        private String language;
        private List<String> keywords;
    }
}