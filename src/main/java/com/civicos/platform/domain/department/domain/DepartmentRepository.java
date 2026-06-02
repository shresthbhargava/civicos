package com.civicos.platform.domain.department.domain;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;
import org.springframework.data.repository.query.Param;

import java.util.List;
import java.util.Optional;

@Repository
public interface DepartmentRepository extends JpaRepository<Department, Long> {

    Optional<Department> findByCode(String code);

    List<Department> findByJurisdictionLevel(JurisdictionLevel level);

    List<Department> findByActiveTrue();

    @Query("""
        SELECT d FROM Department d
        LEFT JOIN FETCH d.parentDepartment
        WHERE d.id = :id
    """)
    Optional<Department> findByIdWithParent(Long id);

    @Query("""
        SELECT d FROM Department d
        LEFT JOIN FETCH d.childDepartments
        WHERE d.parentDepartment IS NULL
        AND d.active = true
    """)
    List<Department> findRootDepartments();
    @Query(value = """
    WITH RECURSIVE accountability_chain AS (
        SELECT id, name, code, jurisdiction_level,
               parent_department_id, ministry, 0 AS depth
        FROM departments
        WHERE id = :departmentId

        UNION ALL

        SELECT d.id, d.name, d.code, d.jurisdiction_level,
               d.parent_department_id, d.ministry, ac.depth + 1
        FROM departments d
        INNER JOIN accountability_chain ac
            ON d.id = ac.parent_department_id
    )
    SELECT * FROM accountability_chain
    ORDER BY depth ASC
    """, nativeQuery = true)
    List<Object[]> findAccountabilityChain(@Param("departmentId") Long departmentId);
}