package com.civicos.platform.domain.department.api;

import com.civicos.platform.common.response.ApiResponse;
import com.civicos.platform.domain.department.application.DepartmentResponse;
import com.civicos.platform.domain.department.application.DepartmentService;
import jakarta.servlet.http.HttpServletRequest;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/v1/departments")
@RequiredArgsConstructor
public class DepartmentController {

    private final DepartmentService departmentService;

    @GetMapping("/{code}")
    public ResponseEntity<ApiResponse<DepartmentResponse>> getDepartment(
            @PathVariable String code,
            HttpServletRequest request
    ) {

        DepartmentResponse response =
                departmentService.getDepartmentByCode(code);

        return ResponseEntity.ok(
                ApiResponse.success(response, request)
        );
    }
}