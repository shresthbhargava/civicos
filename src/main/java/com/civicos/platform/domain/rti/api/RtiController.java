package com.civicos.platform.domain.rti.api;

import com.civicos.platform.common.response.ApiResponse;
import com.civicos.platform.domain.rti.application.RtiRequest;
import com.civicos.platform.domain.rti.application.RtiResponse;
import com.civicos.platform.domain.rti.application.RtiService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.servlet.http.HttpServletRequest;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@Tag(name = "RTI", description = "RTI draft generation")
@RestController
@RequestMapping("/api/v1/rti")
@RequiredArgsConstructor
public class RtiController {

    private final RtiService rtiService;

    @Operation(summary = "Generate RTI draft")
    @PostMapping("/generate")
    public ResponseEntity<ApiResponse<RtiResponse>> generate(
            @RequestBody RtiRequest request,
            HttpServletRequest httpRequest) {
        RtiResponse response = rtiService.generateRti(request);
        return ResponseEntity.ok(ApiResponse.success(response, httpRequest));
    }
}