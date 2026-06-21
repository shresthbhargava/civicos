package com.civicos.platform.domain.department.application;

import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Data;
import lombok.Builder;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;

@Getter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class AccountabilityNode {
    private Long id;
    private String name;
    private String code;
    private String jurisdictionLevel;
    private String ministry;
    private int depth;
}