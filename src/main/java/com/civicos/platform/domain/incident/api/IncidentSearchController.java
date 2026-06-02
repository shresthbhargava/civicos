package com.civicos.platform.domain.incident.api;

import com.civicos.platform.common.exception.CivicOSException;
import com.civicos.platform.common.exception.ErrorCode;
import com.civicos.platform.common.response.ApiResponse;
import com.civicos.platform.domain.incident.application.IncidentCategoryResponse;
import com.civicos.platform.domain.incident.application.IncidentSearchResponse;
import com.civicos.platform.domain.incident.application.IncidentSearchService;
import jakarta.servlet.http.HttpServletRequest;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;


import java.util.List;
import com.civicos.platform.domain.incident.application.LocationContext;
@RestController
@RequestMapping("/api/v1/incidents")
@RequiredArgsConstructor
public class IncidentSearchController {

    private final IncidentSearchService incidentSearchService;

    @GetMapping("/categories")
    public ResponseEntity<ApiResponse<List<IncidentCategoryResponse>>> getAllCategories(
            HttpServletRequest request) {

        List<IncidentCategoryResponse> response =
                incidentSearchService.getAllCategories();

        return ResponseEntity.ok(
                ApiResponse.success(response, request)
        );
    }

    @GetMapping("/search")
    public ResponseEntity<ApiResponse<IncidentSearchResponse>> search(
            @RequestParam String query,
            @RequestParam(required = false) String stateCode,
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