package com.civicos.platform.domain.incident.domain;

import com.civicos.platform.domain.department.domain.Department;
import jakarta.persistence.*;
import lombok.Getter;
import lombok.NoArgsConstructor;

import java.time.Instant;

@Entity
@Table(name = "incident_category_departments")
@Getter
@NoArgsConstructor
public class IncidentCategoryDepartment {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "incident_category_id", nullable = false)
    private IncidentCategory incidentCategory;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "department_id", nullable = false)
    private Department department;

    @Column(name = "responsibility_level", nullable = false)
    private String responsibilityLevel;

    @Column(name = "created_at", nullable = false, updatable = false)
    private Instant createdAt;

    @PrePersist
    protected void onCreate() {
        createdAt = Instant.now();
    }
}