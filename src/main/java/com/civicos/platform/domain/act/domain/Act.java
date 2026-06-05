package com.civicos.platform.domain.act.domain;

import com.civicos.platform.domain.department.domain.Department;
import jakarta.persistence.*;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Entity
@Table(name = "acts")
@Getter
@NoArgsConstructor
public class Act {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false)
    private String name;

    @Column(name = "short_name")
    private String shortName;

    private Integer year;

    private String description;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "governing_department_id")
    private Department governingDepartment;

    @Column(name = "official_url")
    private String officialUrl;

    private Boolean active;
}