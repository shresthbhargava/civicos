package com.civicos.platform.domain.department.application;

import lombok.Builder;
import lombok.Getter;

@Getter
@Builder
public class AccountabilityNode {
    private Long id;
    private String name;
    private String code;
    private String jurisdictionLevel;
    private String ministry;
    private int depth;
}