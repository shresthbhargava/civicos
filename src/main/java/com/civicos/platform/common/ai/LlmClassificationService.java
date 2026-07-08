package com.civicos.platform.common.ai;

import com.civicos.platform.domain.incident.domain.IncidentCategory;
import com.civicos.platform.domain.incident.domain.IncidentCategoryRepository;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.stream.Collectors;

@Slf4j
@Service
public class LlmClassificationService {

    private static final String GROQ_URL = "https://api.groq.com/openai/v1/chat/completions";
    private static final String MODEL = "llama-3.3-70b-versatile";

    private final String apiKey;
    private final HttpClient httpClient;
    private final ObjectMapper objectMapper;
    private final IncidentCategoryRepository categoryRepository;

    public LlmClassificationService(
            @Value("${groq.api-key:}") String apiKey,
            IncidentCategoryRepository categoryRepository) {
        this.apiKey = apiKey;
        this.categoryRepository = categoryRepository;
        this.httpClient = HttpClient.newHttpClient();
        this.objectMapper = new ObjectMapper();
    }

    public Optional<IncidentCategory> classify(String query, String stateCode) {
        if (apiKey == null || apiKey.isBlank()) {
            log.warn("Groq API key not configured, skipping LLM classification");
            return Optional.empty();
        }

        List<IncidentCategory> categories = categoryRepository.findAll();
        if (categories.isEmpty()) {
            log.warn("No categories in DB for LLM classification");
            return Optional.empty();
        }

        String categoryList = categories.stream()
                .map(c -> String.format("- %s [%s]: %s",
                        c.getName(),
                        c.getCode(),
                        c.getDescription() != null ? c.getDescription() : "No description"))
                .collect(Collectors.joining("\n"));

        String systemPrompt = """
                You are a civic complaint classifier for India. Your job is to match a citizen's 
                complaint to the most appropriate category from the provided list.
                Respond with ONLY the category code inside square brackets, e.g. [WATER_SUPPLY].
                If no category matches, respond with [NONE].""";

        String userPrompt = String.format("""
                Available categories:
                %s
                
                Citizen complaint: "%s"
                State: %s
                
                Which category best matches?""", categoryList, query, stateCode != null ? stateCode : "UNKNOWN");

        try {
            Map<String, Object> body = Map.of(
                    "model", MODEL,
                    "messages", List.of(
                            Map.of("role", "system", "content", systemPrompt),
                            Map.of("role", "user", "content", userPrompt)
                    ),
                    "temperature", 0.1,
                    "max_tokens", 30
            );

            HttpRequest request = HttpRequest.newBuilder()
                    .uri(URI.create(GROQ_URL))
                    .header("Content-Type", "application/json")
                    .header("Authorization", "Bearer " + apiKey)
                    .POST(HttpRequest.BodyPublishers.ofString(objectMapper.writeValueAsString(body)))
                    .build();

            HttpResponse<String> response = httpClient.send(request, HttpResponse.BodyHandlers.ofString());

            if (response.statusCode() != 200) {
                log.warn("Groq API returned status {}: {}", response.statusCode(), response.body());
                return Optional.empty();
            }

            JsonNode root = objectMapper.readTree(response.body());
            String content = root.path("choices").path(0).path("message").path("content").asText("").trim();

            // Extract code from [CODE] format
            String code = content.replaceAll("[\\[\\]]", "").trim();

            if (code.equalsIgnoreCase("NONE") || code.isBlank()) {
                log.info("LLM could not classify query: {}", query);
                return Optional.empty();
            }

            return categories.stream()
                    .filter(c -> c.getCode().equalsIgnoreCase(code))
                    .findFirst()
                    .or(() -> {
                        log.warn("LLM returned unknown category code: {}", code);
                        return Optional.empty();
                    });

        } catch (Exception e) {
            log.warn("LLM classification failed for query '{}': {}", query, e.getMessage());
            return Optional.empty();
        }
    }
}