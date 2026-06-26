package com.civicos.platform.domain.complaint.application;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import lombok.*;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ComplaintRequest {

    @NotBlank(message = "Description is required")
    @Size(max = 5000, message = "Description must be under 5000 characters")
    private String description;

    @Size(max = 255)
    private String citizenName;

    @Size(max = 255)
    private String citizenEmail;

    private String stateCode;

    private String districtCode;
}
