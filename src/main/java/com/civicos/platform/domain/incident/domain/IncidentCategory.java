package com.civicos.platform.domain.incident.domain;

import com.civicos.platform.domain.department.domain.Department;
import jakarta.persistence.*;
import lombok.Getter;
import lombok.NoArgsConstructor;
import jakarta.persistence.Column;

import java.time.Instant;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "incident_categories")
@Getter
@NoArgsConstructor
public class IncidentCategory {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false)
    private String name;

    @Column(nullable = false, unique = true)
    private String code;

    @Column(columnDefinition = "TEXT")
    private String description;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "department_id", nullable = false)
    private Department department;

    @Column(columnDefinition = "text[]")
    private String[] keywords;

    @Column(name = "citizen_actions", columnDefinition = "text[]")
    private String[] citizenActions;

    @Column(name = "created_at", nullable = false, updatable = false)
    private Instant createdAt;

    @Column(name = "updated_at", nullable = false)
    private Instant updatedAt;

    @Column(columnDefinition = "vector(768)")
    private String embedding;

    public void setEmbedding(String embedding) {
        this.embedding = embedding;
    }

    public String getEmbedding() {
        return embedding;
    }

    @PreUpdate
    protected void onUpdate() {
        updatedAt = Instant.now();
    }
    @OneToMany(mappedBy = "incidentCategory", fetch = FetchType.LAZY)
    private List<IncidentCategoryDepartment> locationDepartments = new ArrayList<>();
}