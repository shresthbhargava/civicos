package com.civicos.platform.domain.complaint.domain;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.time.Instant;

@Entity
@Table(name = "complaints")
@Getter
@Setter
@NoArgsConstructor
public class Complaint {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "tracking_id", nullable = false, unique = true)
    private String trackingId;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "department_id", nullable = false)
    private com.civicos.platform.domain.department.domain.Department department;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "incident_category_id", nullable = false)
    private com.civicos.platform.domain.incident.domain.IncidentCategory incidentCategory;

    @Enumerated(EnumType.STRING)
    @Column(name = "status", nullable = false, length = 30)
    private ComplaintStatus status = ComplaintStatus.SUBMITTED;

    @Column(name = "description", nullable = false, columnDefinition = "TEXT")
    private String description;

    @Column(name = "citizen_email", length = 255)
    private String citizenEmail;

    @Column(name = "citizen_name", length = 255)
    private String citizenName;

    @Column(name = "state_code", length = 10)
    private String stateCode;

    @Column(name = "district_code", length = 20)
    private String districtCode;

    @Column(name = "resolution_notes", columnDefinition = "TEXT")
    private String resolutionNotes;

    @Column(name = "acknowledged_at")
    private Instant acknowledgedAt;

    @Column(name = "resolved_at")
    private Instant resolvedAt;

    @Column(name = "created_at", nullable = false, updatable = false)
    private Instant createdAt;

    @Column(name = "updated_at", nullable = false)
    private Instant updatedAt;

    @PrePersist
    protected void onCreate() {
        createdAt = Instant.now();
        updatedAt = Instant.now();
    }

    @PreUpdate
    protected void onUpdate() {
        updatedAt = Instant.now();
    }

    public enum ComplaintStatus {
        SUBMITTED, ACKNOWLEDGED, IN_PROGRESS, RESOLVED, REJECTED
    }
}
