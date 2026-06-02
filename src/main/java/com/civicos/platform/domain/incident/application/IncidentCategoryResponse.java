package com.civicos.platform.domain.incident.application;

import com.civicos.platform.domain.incident.domain.IncidentCategory;
import lombok.Getter;

import java.util.Arrays;
import java.util.List;

@Getter
public class IncidentCategoryResponse {

    private final Long id;
    private final String code;
    private final String name;
    private final String description;
    private final IncidentSearchResponse.DepartmentSummary responsibleDepartment;
    private final List<String> citizenActions;

    private IncidentCategoryResponse(
            Long id,
            String code,
            String name,
            String description,
            IncidentSearchResponse.DepartmentSummary responsibleDepartment,
            List<String> citizenActions
    ) {
        this.id = id;
        this.code = code;
        this.name = name;
        this.description = description;
        this.responsibleDepartment = responsibleDepartment;
        this.citizenActions = citizenActions;
    }

    public static IncidentCategoryResponse from(IncidentCategory category) {

        return new IncidentCategoryResponse(
                category.getId(),
                category.getCode(),
                category.getName(),
                category.getDescription(),
                IncidentSearchResponse.DepartmentSummary.from(
                        category.getDepartment()
                ),
                Arrays.asList(category.getCitizenActions())
        );
    }
}