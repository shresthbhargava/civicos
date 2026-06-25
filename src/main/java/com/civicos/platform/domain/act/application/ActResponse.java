package com.civicos.platform.domain.act.application;

import com.civicos.platform.domain.act.domain.Act;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ActResponse {

    String name;
    String shortName;
    Integer year;
    String description;
    String officialUrl;

    public static ActResponse from(Act act) {
        return ActResponse.builder()
                .name(act.getName())
                .shortName(act.getShortName())
                .year(act.getYear())
                .description(act.getDescription())
                .officialUrl(act.getOfficialUrl())
                .build();
    }
}