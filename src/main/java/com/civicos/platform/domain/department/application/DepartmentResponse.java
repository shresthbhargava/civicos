package com.civicos.platform.domain.department.application;

import com.civicos.platform.domain.department.domain.Department;
import lombok.Builder;
import lombok.Getter;

@Getter
@Builder
public class DepartmentResponse {

    private Long id;
    private String code;
    private String name;
    private String jurisdictionLevel;
    private String description;
    private Long parentDepartmentId;

    public static DepartmentResponse from(Department department) {

        return DepartmentResponse.builder()
                .id(department.getId())
                .code(department.getCode())
                .name(department.getName())
                .jurisdictionLevel(
                        department.getJurisdictionLevel().name()
                )
                .description(department.getDescription())
                .parentDepartmentId(
                        department.getParentDepartment() != null
                                ? department.getParentDepartment().getId()
                                : null
                )
                .build();
    }
}