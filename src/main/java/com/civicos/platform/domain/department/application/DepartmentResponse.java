package com.civicos.platform.domain.department.application;

import com.civicos.platform.domain.department.domain.Department;
import lombok.*;

@Getter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class DepartmentResponse {

    private Long id;
    private String code;
    private String name;
    private String jurisdictionLevel;
    private String description;
    private String ministry;
    private String websiteUrl;
    private String complaintPortalUrl;
    private Long parentDepartmentId;

    public static DepartmentResponse from(Department department) {
        return DepartmentResponse.builder()
                .id(department.getId())
                .code(department.getCode())
                .name(department.getName())
                .jurisdictionLevel(department.getJurisdictionLevel().name())
                .description(department.getDescription())
                .ministry(department.getMinistry())
                .websiteUrl(department.getWebsiteUrl())
                .complaintPortalUrl(department.getComplaintPortalUrl())
                .parentDepartmentId(
                        department.getParentDepartment() != null
                                ? department.getParentDepartment().getId()
                                : null
                )
                .build();
    }
}
