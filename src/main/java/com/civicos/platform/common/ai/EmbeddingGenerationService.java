package com.civicos.platform.common.ai;

import com.civicos.platform.domain.incident.domain.IncidentCategoryRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Slf4j
@Service
@RequiredArgsConstructor
public class EmbeddingGenerationService {

    private final IncidentCategoryRepository incidentCategoryRepository;
    private final EmbeddingService embeddingService;

    @Transactional
    public void generateEmbeddingsForAll() {
        var categories = incidentCategoryRepository.findAll();

        log.info("Generating embeddings for {} categories", categories.size());

        for (var category : categories) {
            String text = buildEmbeddingText(category.getName(),
                    category.getDescription(),
                    category.getKeywords());

            String embedding = embeddingService.getEmbedding(text);
            category.setEmbedding(embedding);
            incidentCategoryRepository.save(category);

            log.info("Generated embedding for category: {}", category.getCode());
        }

        log.info("Done generating embeddings for all categories");
    }

    private String buildEmbeddingText(String name, String description, String[] keywords) {
        StringBuilder sb = new StringBuilder();
        sb.append(name).append(". ");
        if (description != null) sb.append(description).append(". ");
        if (keywords != null) sb.append(String.join(", ", keywords));
        return sb.toString();
    }
}