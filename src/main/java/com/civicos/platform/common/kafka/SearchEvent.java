package com.civicos.platform.common.kafka;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.Instant;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class SearchEvent {
    private String query;
    private String stateCode;
    private String districtCode;
    private String matchType;
    private int matchCount;
    private String topCategory;
    private Instant timestamp;
}