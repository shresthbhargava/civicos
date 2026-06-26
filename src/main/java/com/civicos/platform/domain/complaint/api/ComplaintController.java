package com.civicos.platform.domain.complaint.api;

import com.civicos.platform.common.response.ApiResponse;
import com.civicos.platform.domain.complaint.application.ComplaintRequest;
import com.civicos.platform.domain.complaint.application.ComplaintResponse;
import com.civicos.platform.domain.complaint.application.ComplaintService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@Tag(name = "Complaints", description = "File and track citizen complaints against government departments")
@RestController
@RequestMapping("/api/v1/complaints")
@RequiredArgsConstructor
public class ComplaintController {

    private final ComplaintService complaintService;

    @Operation(summary = "File a new complaint",
            description = "Submits a complaint against a specific department for an incident category. Returns a tracking ID.")
    @PostMapping
    public ResponseEntity<ApiResponse<ComplaintResponse>> fileComplaint(
            @Valid @RequestBody ComplaintRequest request,
            @Parameter(description = "Incident category code e.g. ROAD_DAMAGE, EXAM_IRREGULARITY")
            @RequestParam String categoryCode,
            @Parameter(description = "Department code e.g. MORTH_CENTRAL, NTA_CENTRAL")
            @RequestParam String departmentCode,
            HttpServletRequest httpRequest) {

        ComplaintResponse response = complaintService.fileComplaint(request, categoryCode, departmentCode);
        return ResponseEntity.ok(ApiResponse.success(response, httpRequest));
    }

    @Operation(summary = "Track complaint by ID",
            description = "Lookup a complaint's current status using its tracking ID.")
    @GetMapping("/track/{trackingId}")
    public ResponseEntity<ApiResponse<ComplaintResponse>> trackComplaint(
            @PathVariable String trackingId,
            HttpServletRequest httpRequest) {

        ComplaintResponse response = complaintService.getByTrackingId(trackingId);
        return ResponseEntity.ok(ApiResponse.success(response, httpRequest));
    }

    @Operation(summary = "Get complaints by department",
            description = "List all complaints filed against a specific department, paginated.")
    @GetMapping("/department/{departmentCode}")
    public ResponseEntity<ApiResponse<Page<ComplaintResponse>>> getByDepartment(
            @PathVariable String departmentCode,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size,
            HttpServletRequest httpRequest) {

        Page<ComplaintResponse> complaints = complaintService.getByDepartment(departmentCode, page, size);
        return ResponseEntity.ok(ApiResponse.success(complaints, httpRequest));
    }

    @Operation(summary = "Get complaints by status",
            description = "List all complaints with a specific status, paginated.")
    @GetMapping("/status/{status}")
    public ResponseEntity<ApiResponse<Page<ComplaintResponse>>> getByStatus(
            @PathVariable String status,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size,
            HttpServletRequest httpRequest) {

        Page<ComplaintResponse> complaints = complaintService.getByStatus(status, page, size);
        return ResponseEntity.ok(ApiResponse.success(complaints, httpRequest));
    }

    @Operation(summary = "Update complaint status",
            description = "Transition a complaint's status. Valid transitions: SUBMITTED→ACKNOWLEDGED, ACKNOWLEDGED→IN_PROGRESS, IN_PROGRESS→RESOLVED/REJECTED")
    @PatchMapping("/{trackingId}/status")
    public ResponseEntity<ApiResponse<ComplaintResponse>> updateStatus(
            @PathVariable String trackingId,
            @RequestParam String status,
            HttpServletRequest httpRequest) {

        ComplaintResponse response = complaintService.updateStatus(trackingId, status);
        return ResponseEntity.ok(ApiResponse.success(response, httpRequest));
    }
}
