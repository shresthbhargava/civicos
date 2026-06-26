package com.civicos.platform.domain.project.domain;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.time.Instant;
import java.time.LocalDate;

@Entity
@Table(name = "government_projects")
@Getter
@Setter
@NoArgsConstructor
public class GovernmentProject {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, length = 300)
    private String name;

    @Column(nullable = false, unique = true, length = 100)
    private String slug;

    @Column(nullable = false, columnDefinition = "TEXT")
    private String description;

    @Column(name = "department_code", nullable = false, length = 50)
    private String departmentCode;

    @Column(length = 200)
    private String ministry;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 30)
    private ProjectStatus status = ProjectStatus.IN_PROGRESS;

    @Column(name = "total_budget_cr", nullable = false)
    private Long totalBudgetCr;

    @Column(name = "spent_cr", nullable = false)
    private Long spentCr = 0L;

    @Column(name = "start_date")
    private LocalDate startDate;

    @Column(name = "target_completion_date")
    private LocalDate targetCompletionDate;

    @Column(name = "actual_completion_date")
    private LocalDate actualCompletionDate;

    @Column(name = "state_code", length = 10)
    private String stateCode;

    @Column(name = "implementing_agency", length = 200)
    private String implementingAgency;

    @Column(nullable = false, length = 50)
    private String category;

    @Column(name = "created_at", nullable = false, updatable = false)
    private Instant createdAt;

    @Column(name = "updated_at", nullable = false)
    private Instant updatedAt;

    @PrePersist
    protected void onCreate() { createdAt = Instant.now(); updatedAt = Instant.now(); }
    @PreUpdate
    protected void onUpdate() { updatedAt = Instant.now(); }

    public enum ProjectStatus {
        ANNOUNCED, IN_PROGRESS, COMPLETED, DELAYED, STALLED
    }

    public double getCompletionPercentage() {
        if (totalBudgetCr == null || totalBudgetCr == 0) return 0;
        return Math.min(100.0, (spentCr * 100.0) / totalBudgetCr);
    }
}