package com.civicos.platform.domain.news.domain;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.hibernate.annotations.JdbcTypeCode;
import org.hibernate.type.SqlTypes;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;

@Entity
@Table(name = "daily_editions")
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class DailyEdition {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    @Column(name="edition_date",nullable = false,unique = true)
    private LocalDate editionDate;
    @Column(length=500)
    private String headline;
    @JdbcTypeCode(SqlTypes.JSON)
    @Column(columnDefinition="jsonb")
    private List<Map<String,Object>> stories;
    @Column(name="generated_at")
    private LocalDateTime generatedAt;



}
