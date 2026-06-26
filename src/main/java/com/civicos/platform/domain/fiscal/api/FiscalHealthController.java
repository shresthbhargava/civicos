package com.civicos.platform.domain.fiscal.api;

import com.civicos.platform.common.response.ApiResponse;
import com.civicos.platform.domain.fiscal.application.FiscalHealthResponse;
import com.civicos.platform.domain.fiscal.application.FiscalHealthService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.servlet.http.HttpServletRequest;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Tag(name = "Fiscal Health", description = "State fiscal health data and rankings")
@RestController
@RequestMapping("/api/v1/fiscal-health")
@RequiredArgsConstructor
public class FiscalHealthController {

    private final FiscalHealthService fiscalHealthService;

    @Operation(summary = "Get all states fiscal health (latest year)")
    @GetMapping
    public ResponseEntity<ApiResponse<List<FiscalHealthResponse>>> getAll(HttpServletRequest request) {
        return ResponseEntity.ok(ApiResponse.success(fiscalHealthService.getLatestFiscalHealth(), request));
    }

    @Operation(summary = "Get fiscal health for a specific state")
    @GetMapping("/{stateCode}")
    public ResponseEntity<ApiResponse<FiscalHealthResponse>> getByState(
            @PathVariable String stateCode, HttpServletRequest request) {
        FiscalHealthResponse data = fiscalHealthService.getByState(stateCode);
        return ResponseEntity.ok(ApiResponse.success(data, request));
    }
}