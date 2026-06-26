package com.civicos.platform.domain.project.api;

import com.civicos.platform.common.response.ApiResponse;
import com.civicos.platform.domain.project.application.ProjectResponse;
import com.civicos.platform.domain.project.application.ProjectService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.servlet.http.HttpServletRequest;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Tag(name = "Projects", description = "Government project tracking and status")
@RestController
@RequestMapping("/api/v1/projects")
@RequiredArgsConstructor
public class ProjectController {

    private final ProjectService projectService;

    @Operation(summary = "Get all projects ordered by budget")
    @GetMapping
    public ResponseEntity<ApiResponse<List<ProjectResponse>>> getAll(HttpServletRequest request) {
        return ResponseEntity.ok(ApiResponse.success(projectService.getAllProjects(), request));
    }

    @Operation(summary = "Get active (non-completed) projects")
    @GetMapping("/active")
    public ResponseEntity<ApiResponse<List<ProjectResponse>>> getActive(HttpServletRequest request) {
        return ResponseEntity.ok(ApiResponse.success(projectService.getActiveProjects(), request));
    }

    @Operation(summary = "Get project by slug")
    @GetMapping("/slug/{slug}")
    public ResponseEntity<ApiResponse<ProjectResponse>> getBySlug(
            @PathVariable String slug, HttpServletRequest request) {
        return ResponseEntity.ok(ApiResponse.success(projectService.getBySlug(slug), request));
    }

    @Operation(summary = "Filter projects by status")
    @GetMapping("/status/{status}")
    public ResponseEntity<ApiResponse<List<ProjectResponse>>> getByStatus(
            @PathVariable String status, HttpServletRequest request) {
        return ResponseEntity.ok(ApiResponse.success(projectService.getByStatus(status), request));
    }
}