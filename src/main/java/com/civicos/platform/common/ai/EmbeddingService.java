package com.civicos.platform.common.ai;

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

@Slf4j
@Service
public class EmbeddingService {

    private final String ollamaUrl;
    private final HttpClient httpClient;
    private final ObjectMapper objectMapper;

    public EmbeddingService(
            @Value("${ollama.url:http://localhost:11434}") String ollamaUrl) {
        this.ollamaUrl = ollamaUrl;
        this.httpClient = HttpClient.newHttpClient();
        this.objectMapper = new ObjectMapper();
    }

    public String getEmbedding(String text) {
        try {
            log.debug("Generating embedding for: {}", text);

            String body = objectMapper.writeValueAsString(
                    Map.of("model", "nomic-embed-text", "prompt", text)
            );

            HttpRequest request = HttpRequest.newBuilder()
                    .uri(URI.create(ollamaUrl + "/api/embeddings"))
                    .header("Content-Type", "application/json")
                    .POST(HttpRequest.BodyPublishers.ofString(body))
                    .build();

            HttpResponse<String> response = httpClient.send(
                    request, HttpResponse.BodyHandlers.ofString()
            );

            var responseMap = objectMapper.readValue(response.body(), Map.class);
            List<Double> embedding = (List<Double>) responseMap.get("embedding");

            StringBuilder sb = new StringBuilder("[");
            for (int i = 0; i < embedding.size(); i++) {
                sb.append(embedding.get(i).floatValue());
                if (i < embedding.size() - 1) sb.append(",");
            }
            sb.append("]");
            return sb.toString();

        } catch (Exception e) {
            throw new RuntimeException("Failed to generate embedding", e);
        }
    }
}