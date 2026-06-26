package com.civicos.platform.domain.complaint.application;

import com.civicos.platform.domain.complaint.domain.Complaint;
import lombok.*;

import java.time.Instant;

@Getter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ComplaintResponse {

    private Long id;
    private String trackingId;
    private String description;
    private String status;
    private String categoryName;
    private String categoryCode;
    private String departmentName;
    private String departmentCode;
    private String complaintPortalUrl;
    private String citizenEmail;
    private String citizenName;
    private String stateCode;
    private String districtCode;
    private String resolutionNotes;
    private Instant acknowledgedAt;
    private Instant resolvedAt;
    private Instant createdAt;

    public static ComplaintResponse from(Complaint complaint) {
        return ComplaintResponse.builder()
                .id(complaint.getId())
                .trackingId(complaint.getTrackingId())
                .description(complaint.getDescription())
                .status(complaint.getStatus().name())
                .categoryName(complaint.getIncidentCategory().getName())
                .categoryCode(complaint.getIncidentCategory().getCode())
                .departmentName(complaint.getDepartment().getName())
                .departmentCode(complaint.getDepartment().getCode())
                .complaintPortalUrl(complaint.getDepartment().getComplaintPortalUrl())
                .citizenEmail(complaint.getCitizenEmail())
                .citizenName(complaint.getCitizenName())
                .stateCode(complaint.getStateCode())
                .districtCode(complaint.getDistrictCode())
                .resolutionNotes(complaint.getResolutionNotes())
                .acknowledgedAt(complaint.getAcknowledgedAt())
                .resolvedAt(complaint.getResolvedAt())
                .createdAt(complaint.getCreatedAt())
                .build();
    }
}
