package com.civicos.platform.common.cache;

import com.civicos.platform.common.response.ApiResponse;
import jakarta.servlet.http.HttpServletRequest;
import lombok.RequiredArgsConstructor;
import org.springframework.cache.CacheManager;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/v1/admin")
@RequiredArgsConstructor
public class CacheController {

    private final CacheManager cacheManager;

    @DeleteMapping("/cache")
    public ResponseEntity<ApiResponse<String>> clearAllCaches(HttpServletRequest request) {
        cacheManager.getCacheNames()
                .forEach(cacheName -> cacheManager.getCache(cacheName).clear());
        return ResponseEntity.ok(ApiResponse.success("All caches cleared", request));
    }
}