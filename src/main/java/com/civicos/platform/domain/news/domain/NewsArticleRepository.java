package com.civicos.platform.domain.news.domain;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface NewsArticleRepository extends JpaRepository<NewsArticle, Long> {

    Optional<NewsArticle> findByArticleId(String articleId);

    List<NewsArticle> findTop10ByOrderByPublishedAtDesc();

    List<NewsArticle> findTop5ByCategoryOrderByPublishedAtDesc(String category);
}