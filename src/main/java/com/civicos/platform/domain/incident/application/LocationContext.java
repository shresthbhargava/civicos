package com.civicos.platform.domain.incident.application;

import lombok.Builder;
import lombok.Getter;

@Getter
@Builder
public class LocationContext {

    private final String stateCode;
    private final String districtCode;

    public static LocationContext empty() {
        return LocationContext.builder()
                .stateCode(null)
                .districtCode(null)
                .build();
    }

    public static LocationContext ofState(String stateCode) {
        return LocationContext.builder()
                .stateCode(stateCode)
                .districtCode(null)
                .build();
    }

    public static LocationContext ofDistrict(String stateCode, String districtCode) {
        return LocationContext.builder()
                .stateCode(stateCode)
                .districtCode(districtCode)
                .build();
    }

    public boolean hasLocation() {
        return stateCode != null && !stateCode.isBlank();
    }
}