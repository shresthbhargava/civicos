package com.civicos.platform.domain.incident.domain;

import lombok.AllArgsConstructor;
import lombok.Getter;

@Getter
@AllArgsConstructor
public class IncidentSearchResult {
    private Long categoryId;
    private String categoryName;
    private String categoryCode;
    private String categoryDescription;
    private String[] keywords;
    private String[] citizenActions;

    // The resolved department — most specific for the given location
    private Long resolvedDepartmentId;
    private String resolvedDepartmentCode;
    private String resolvedDepartmentName;
    private String resolvedDepartmentJurisdictionLevel;
    private String resolvedDepartmentJurisdictionValue;
}