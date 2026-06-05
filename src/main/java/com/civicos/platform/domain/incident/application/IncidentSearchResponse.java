package com.civicos.platform.domain.incident.application;

import com.civicos.platform.domain.department.application.AccountabilityNode;
import com.civicos.platform.domain.department.domain.Department;
import com.civicos.platform.domain.official.application.OfficialResponse;
import com.civicos.platform.domain.act.application.ActResponse;
import lombok.Builder;
import lombok.Getter;

import java.util.List;

@Getter
@Builder
public class IncidentSearchResponse {

    private String query;
    private String matchType;
    private List<IncidentMatch> matches;

    @Getter
    @Builder
    public static class IncidentMatch {

        private Long categoryId;
        private String categoryName;
        private String categoryCode;
        private List<String> matchedKeywords;
        private DepartmentSummary responsibleDepartment;
        private List<AccountabilityNode> accountabilityChain;
        private List<String> citizenActions;
        private List<ActResponse> relevantActs;

    }

    @Getter
    @Builder
    public static class DepartmentSummary {

        private Long id;
        private String code;
        private String name;
        private String jurisdictionLevel;
        private List<OfficialResponse> currentOfficials;

        public static DepartmentSummary from(Department department) {

            return DepartmentSummary.builder()
                    .id(department.getId())
                    .code(department.getCode())
                    .name(department.getName())
                    .jurisdictionLevel(
                            department.getJurisdictionLevel().name()
                    )
                    .build();
        }
    }
}