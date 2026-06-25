package com.civicos.platform.domain.news.application;

import com.civicos.platform.AbstractIntegrationTest;
import com.civicos.platform.domain.news.domain.DailyEdition;
import com.civicos.platform.domain.news.domain.DailyEditionRepository;
import com.civicos.platform.domain.news.domain.NewsArticle;
import com.civicos.platform.domain.news.domain.NewsArticleRepository;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;

import static org.assertj.core.api.Assertions.assertThat;

class DailyEditionServiceTest extends AbstractIntegrationTest {

    @Autowired
    private DailyEditionService dailyEditionService;

    @Autowired
    private DailyEditionRepository dailyEditionRepository;

    @Autowired
    private NewsArticleRepository newsArticleRepository;

    @BeforeEach
    void cleanUp() {
        dailyEditionRepository.deleteAll();
        newsArticleRepository.deleteAll();
    }

    private NewsArticle seedArticle(String title) {
        return newsArticleRepository.save(
                NewsArticle.builder()
                        .title(title)
                        .description("Test description for " + title)
                        .sourceName("Test Source")
                        .sourceUrl("https://example.com/test")
                        .publishedAt(LocalDateTime.now())
                        .build()
        );
    }

    @Test
    @DisplayName("Generating an edition when none exists for today creates one")
    void generateDailyEdition_noExistingEdition_createsNewEdition() {
        seedArticle("NTA: A System Built On Scams?");

        dailyEditionService.generateDailyEdition(false);

        var edition = dailyEditionRepository.findByEditionDate(LocalDate.now());
        assertThat(edition).isPresent();
        assertThat(edition.get().getStories()).isNotEmpty();
    }

    @Test
    @DisplayName("Calling generate again without force does NOT overwrite today's edition")
    void generateDailyEdition_alreadyExists_withoutForce_doesNothing() {
        seedArticle("NTA: A System Built On Scams?");
        dailyEditionService.generateDailyEdition(false);

        var firstGeneratedAt = dailyEditionRepository
                .findByEditionDate(LocalDate.now())
                .orElseThrow()
                .getGeneratedAt();

        // Seed a second article and try to regenerate without force.
        // This mirrors the exact bug found in production: a second call
        // returning "success" while silently doing nothing.
        seedArticle("Completely Different Headline");
        dailyEditionService.generateDailyEdition(false);

        var secondGeneratedAt = dailyEditionRepository
                .findByEditionDate(LocalDate.now())
                .orElseThrow()
                .getGeneratedAt();

        assertThat(secondGeneratedAt).isEqualTo(firstGeneratedAt);
    }

    @Test
    @DisplayName("Calling generate with force=true overwrites today's edition with a fresh timestamp")
    void generateDailyEdition_alreadyExists_withForce_overwritesEdition() {
        seedArticle("NTA: A System Built On Scams?");
        dailyEditionService.generateDailyEdition(false);

        Long originalId = dailyEditionRepository
                .findByEditionDate(LocalDate.now())
                .orElseThrow()
                .getId();
        var firstGeneratedAt = dailyEditionRepository
                .findByEditionDate(LocalDate.now())
                .orElseThrow()
                .getGeneratedAt();

        // Small delay so a fresh LocalDateTime.now() is guaranteed to differ.
        try { Thread.sleep(10); } catch (InterruptedException ignored) {}

        dailyEditionService.generateDailyEdition(true);

        var afterForce = dailyEditionRepository
                .findByEditionDate(LocalDate.now())
                .orElseThrow();

        // Same row gets updated (UPDATE, not a conflicting INSERT) -
        // this is the unique-constraint issue we specifically designed
        // existingOpt.orElseGet(DailyEdition::new) to avoid.
        assertThat(afterForce.getId()).isEqualTo(originalId);
        assertThat(afterForce.getGeneratedAt()).isAfter(firstGeneratedAt);
    }

    @Test
    @DisplayName("NTA headline resolves to Examination Irregularity with an accountable department")
    void generateDailyEdition_ntaHeadline_resolvesAccountability() {
        seedArticle("NTA: A System Built On Scams?");

        dailyEditionService.generateDailyEdition(true);

        DailyEdition edition = dailyEditionRepository
                .findByEditionDate(LocalDate.now())
                .orElseThrow();

        Map<String, Object> story = edition.getStories().get(0);

        // This is the exact production bug fixed via V18: "nta" was missing
        // from EXAM_IRREGULARITY's keywords array, so this assertion would
        // have failed before that migration.
        assertThat(story.get("categoryName")).isEqualTo("Examination Irregularity");
        assertThat(story.get("accountableDepartment")).isEqualTo("National Testing Agency");
        assertThat(story.get("citizenActions")).isNotNull();
    }

    @Test
    @DisplayName("Headline with no keyword match still produces a story, just without accountability fields")
    void generateDailyEdition_noKeywordMatch_storyHasNoAccountabilityFields() {
        seedArticle("Local Bakery Wins Award For Best Croissant");

        dailyEditionService.generateDailyEdition(true);

        DailyEdition edition = dailyEditionRepository
                .findByEditionDate(LocalDate.now())
                .orElseThrow();

        Map<String, Object> story = edition.getStories().get(0);

        assertThat(story.get("title")).isEqualTo("Local Bakery Wins Award For Best Croissant");
        assertThat(story.containsKey("accountableDepartment")).isFalse();
    }

    @Test
    @DisplayName("Edition headline is the most recent article's title, uppercased")
    void generateDailyEdition_headline_isFirstArticleTitleUppercased() {
        seedArticle("this is a lowercase test headline");

        dailyEditionService.generateDailyEdition(true);

        DailyEdition edition = dailyEditionRepository
                .findByEditionDate(LocalDate.now())
                .orElseThrow();

        assertThat(edition.getHeadline()).isEqualTo("THIS IS A LOWERCASE TEST HEADLINE");
    }

    @Test
    @DisplayName("No articles available means no edition is created")
    void generateDailyEdition_noArticles_doesNotCreateEdition() {
        dailyEditionService.generateDailyEdition(false);

        var edition = dailyEditionRepository.findByEditionDate(LocalDate.now());
        assertThat(edition).isEmpty();
    }
}