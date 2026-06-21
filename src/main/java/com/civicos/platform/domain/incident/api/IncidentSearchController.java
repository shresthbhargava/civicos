package com.civicos.platform.domain.incident.api;

import com.civicos.platform.common.exception.CivicOSException;
import com.civicos.platform.common.exception.ErrorCode;
import com.civicos.platform.common.response.ApiResponse;
import com.civicos.platform.domain.incident.application.IncidentCategoryResponse;
import com.civicos.platform.domain.incident.application.IncidentSearchResponse;
import com.civicos.platform.domain.incident.application.IncidentSearchService;
import com.civicos.platform.domain.incident.application.LocationContext;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.servlet.http.HttpServletRequest;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Tag(name = "Incident Search", description = "Search for civic incidents and find accountable departments")
@RestController
@RequestMapping("/api/v1/incidents")
@RequiredArgsConstructor
public class IncidentSearchController {

    private final IncidentSearchService incidentSearchService;

    @Operation(summary = "Get all incident categories")
    @GetMapping("/categories")
    public ResponseEntity<ApiResponse<List<IncidentCategoryResponse>>> getAllCategories(
            HttpServletRequest request) {
        return ResponseEntity.ok(
                ApiResponse.success(incidentSearchService.getAllCategories(), request)
        );
    }

    @Operation(
            summary = "Search incidents",
            description = "Search for civic incidents by keyword. Returns responsible department, accountability chain, current officials, relevant acts and citizen actions."
    )
    @GetMapping("/search")
    public ResponseEntity<ApiResponse<IncidentSearchResponse>> search(
            @Parameter(description = "Search query e.g. 'exam leak', 'water supply'")
            @RequestParam String query,
            @Parameter(description = "State code e.g. MH, DL, KA, TN, UP")
            @RequestParam(required = false) String stateCode,
            @Parameter(description = "District code")
            @RequestParam(required = false) String districtCode,
            HttpServletRequest request) {

        if (query == null || query.isBlank() || query.trim().length() < 3) {
            throw new CivicOSException(
                    ErrorCode.BAD_REQUEST,
                    "Search query must be at least 3 characters"
            );
        }

        LocationContext location = resolveLocation(stateCode, districtCode);
        IncidentSearchResponse response = incidentSearchService.search(query, location);
        return ResponseEntity.ok(ApiResponse.success(response, request));
    }

    private LocationContext resolveLocation(String stateCode, String districtCode) {
        if (districtCode != null && !districtCode.isBlank()
                && stateCode != null && !stateCode.isBlank()) {
            return LocationContext.ofDistrict(stateCode, districtCode);
        }
        if (stateCode != null && !stateCode.isBlank()) {
            return LocationContext.ofState(stateCode);
        }
        return LocationContext.empty();
    }
}