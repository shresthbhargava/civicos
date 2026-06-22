package com.civicos.platform.domain.news.domain;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Entity
@Table(name = "news_articles")
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class NewsArticle {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, length = 500)
    private String title;

    @Column(columnDefinition = "TEXT")
    private String description;

    @Column(columnDefinition = "TEXT")
    private String content;

    @Column(name = "source_name", length = 200)
    private String sourceName;

    @Column(name = "source_url", length = 500)
    private String sourceUrl;

    @Column(name = "image_url", length = 500)
    private String imageUrl;

    private String category;
    private String country;
    private String language;

    @Column(name = "published_at")
    private LocalDateTime publishedAt;

    @Column(name = "article_id", unique = true, length = 200)
    private String articleId;

    @Column(columnDefinition = "text[]")
    private String[] tags;

    @Column(name = "created_at")
    private LocalDateTime createdAt;
}