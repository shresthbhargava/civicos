package com.civicos.platform.domain.incident.domain;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface IncidentCategoryRepository
        extends JpaRepository<IncidentCategory, Long> {

    @Query(value = """
SELECT DISTINCT ON (ic.id)
    ic.id,
    ic.name,
    ic.code,
    ic.description,
    ic.keywords,
    ic.citizen_actions,
    ic.created_at,
    ic.updated_at,

    COALESCE(d_specific.id, d_default.id) as dept_id,
    COALESCE(d_specific.code, d_default.code) as dept_code,
    COALESCE(d_specific.name, d_default.name) as dept_name,
    COALESCE(
        d_specific.jurisdiction_level,
        d_default.jurisdiction_level
    ) as dept_jurisdiction

FROM incident_categories ic

JOIN departments d_default
    ON ic.department_id = d_default.id

LEFT JOIN incident_category_departments icd
    ON ic.id = icd.incident_category_id

LEFT JOIN departments d_specific
    ON icd.department_id = d_specific.id
    AND (
        (d_specific.jurisdiction_level = 'STATE'
            AND d_specific.jurisdiction_value = :stateCode)
        OR
        (d_specific.jurisdiction_level = 'DISTRICT'
            AND d_specific.jurisdiction_value = :districtCode)
    )

WHERE ic.keywords && CAST(:keywords AS text[])

ORDER BY
    ic.id,
    CASE
        WHEN d_specific.jurisdiction_level = 'DISTRICT' THEN 1
        WHEN d_specific.jurisdiction_level = 'STATE' THEN 2
        ELSE 3
    END
""", nativeQuery = true)
    List<Object[]> searchByKeywordsAndLocation(
            @Param("keywords") String[] keywords,
            @Param("stateCode") String stateCode,
            @Param("districtCode") String districtCode
    );
}