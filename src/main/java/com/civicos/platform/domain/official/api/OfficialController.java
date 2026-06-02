package com.civicos.platform.domain.official.api;

import com.civicos.platform.common.exception.CivicOSException;
import com.civicos.platform.common.exception.ErrorCode;
import com.civicos.platform.common.response.ApiResponse;
import com.civicos.platform.domain.official.application.OfficialResponse;
import com.civicos.platform.domain.official.application.OfficialService;
import com.civicos.platform.domain.department.domain.DepartmentRepository;
import jakarta.servlet.http.HttpServletRequest;
import lombok.RequiredArgsConstructor;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.util.List;

@RestController
@RequestMapping("/api/v1/departments")
@RequiredArgsConstructor
public class OfficialController {

    private final OfficialService officialService;
    private final DepartmentRepository departmentRepository;

    @GetMapping("/{code}/officials")
    public ResponseEntity<ApiResponse<List<OfficialResponse>>> getOfficials(
            @PathVariable String code,
            @RequestParam(required = false)
            @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate asOf,
            HttpServletRequest request) {

        LocalDate queryDate = asOf != null ? asOf : LocalDate.now();

        Long departmentId = departmentRepository.findByCode(code)
                .orElseThrow(() -> new CivicOSException(
                        ErrorCode.DEPARTMENT_NOT_FOUND,
                        "Department not found: " + code))
                .getId();

        List<OfficialResponse> officials = officialService.getOfficialsAsOf(departmentId, queryDate);
        return ResponseEntity.ok(ApiResponse.success(officials, request));
    }
}