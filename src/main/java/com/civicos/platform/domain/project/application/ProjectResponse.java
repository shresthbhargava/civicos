package com.civicos.platform.domain.project.application;

import com.civicos.platform.domain.project.domain.GovernmentProject;
import lombok.*;

@Getter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ProjectResponse {

    private Long id;
    private String name;
    private String slug;
    private String description;
    private String departmentCode;
    private String ministry;
    private String status;
    private Long totalBudgetCr;
    private Long spentCr;
    private Double completionPercentage;
    private String startDate;
    private String targetCompletionDate;
    private String stateCode;
    private String implementingAgency;
    private String category;

    public static ProjectResponse from(GovernmentProject entity) {
        return ProjectResponse.builder()
                .id(entity.getId())
                .name(entity.getName())
                .slug(entity.getSlug())
                .description(entity.getDescription())
                .departmentCode(entity.getDepartmentCode())
                .ministry(entity.getMinistry())
                .status(entity.getStatus().name())
                .totalBudgetCr(entity.getTotalBudgetCr())
                .spentCr(entity.getSpentCr())
                .completionPercentage(entity.getCompletionPercentage())
                .startDate(entity.getStartDate() != null ? entity.getStartDate().toString() : null)
                .targetCompletionDate(entity.getTargetCompletionDate() != null ? entity.getTargetCompletionDate().toString() : null)
                .stateCode(entity.getStateCode())
                .implementingAgency(entity.getImplementingAgency())
                .category(entity.getCategory())
                .build();
    }
}