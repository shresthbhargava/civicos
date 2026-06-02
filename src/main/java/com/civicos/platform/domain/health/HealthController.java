package com.civicos.platform.domain.health;

import com.civicos.platform.common.exception.CivicOSException;
import com.civicos.platform.common.exception.ErrorCode;
import com.civicos.platform.common.response.ApiResponse;
import lombok.extern.slf4j.Slf4j;
import org.slf4j.MDC;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.Map;
import jakarta.servlet.http.HttpServletRequest;
@Slf4j
@RestController
@RequestMapping("/api/v1")
public class HealthController {

    @GetMapping("/status")
    public ResponseEntity<ApiResponse<Map<String, String>>> status(
            HttpServletRequest request)  {
        log.info("Status endpoint called");

        Map<String, String> data = Map.of(
                "service", "civicos-platform",
                "status", "operational",
                "version", "0.1.0"
        );

        return ResponseEntity.ok(
                ApiResponse.success(data, request)
        );
    }

    @GetMapping("/status/error-test")
    public ResponseEntity<ApiResponse<Void>> errorTest(
            @RequestParam(defaultValue = "domain") String type) {

        if ("domain".equals(type)) {
            throw new CivicOSException(
                    ErrorCode.DEPARTMENT_NOT_FOUND,
                    "Test domain exception"
            );
        }

        throw new RuntimeException("Test unexpected exception");
    }
}