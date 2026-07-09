package com.civicos.platform.domain.rti.application;

public record RtiRequest(
        String categoryCode,
        String departmentCode,
        String citizenName,
        String citizenAddress,
        String citizenEmail,
        String stateCode,
        String districtCode
) {}