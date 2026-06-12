package com.civicos.platform.common.ai;

import com.civicos.platform.common.response.ApiResponse;
import jakarta.servlet.http.HttpServletRequest;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/v1/admin")
@RequiredArgsConstructor
public class EmbeddingController {

    private final EmbeddingGenerationService embeddingGenerationService;

    @PostMapping("/generate-embeddings")
    public ResponseEntity<ApiResponse<String>> generateEmbeddings(
            HttpServletRequest request) {
        embeddingGenerationService.generateEmbeddingsForAll();
        return ResponseEntity.ok(ApiResponse.success("Embeddings generated", request));
    }
}