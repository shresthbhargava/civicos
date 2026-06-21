package com.civicos.platform.domain.official.application;

import com.civicos.platform.domain.official.domain.OfficialPosting;
import lombok.Builder;
import lombok.Getter;

import java.time.LocalDate;
import lombok.Data;
import lombok.Builder;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;

@Data

@NoArgsConstructor
@AllArgsConstructor


@Getter
@Builder
public class OfficialResponse {

    private Long id;
    private String fullName;
    private String postingTitle;
    private String rank;
    private String contactEmail;
    private LocalDate startDate;
    private String sourceUrl;

    public static OfficialResponse from(OfficialPosting posting) {
        return OfficialResponse.builder()
                .id(posting.getOfficial().getId())
                .fullName(posting.getOfficial().getFullName())
                .postingTitle(posting.getPostingTitle())
                .rank(posting.getOfficial().getRank())
                .contactEmail(posting.getOfficial().getContactEmail())
                .startDate(posting.getStartDate())
                .sourceUrl(posting.getSourceUrl())
                .build();
    }
}