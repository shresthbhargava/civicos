package com.civicos.platform.domain.department.application;

import com.civicos.platform.common.exception.CivicOSException;
import com.civicos.platform.common.exception.ErrorCode;
import com.civicos.platform.domain.department.domain.Department;
import com.civicos.platform.domain.department.domain.DepartmentRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class DepartmentService {

    private final DepartmentRepository departmentRepository;

    public DepartmentResponse getDepartmentByCode(String code) {

        Department department = departmentRepository
                .findByCode(code)
                .orElseThrow(() -> new CivicOSException(
                        ErrorCode.DEPARTMENT_NOT_FOUND,
                        "Department not found with code: " + code
                ));

        return DepartmentResponse.from(department);
    }
}