package com.civicos.platform.domain.official.domain;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
import java.util.List;

@Repository
public interface OfficialPostingRepository extends JpaRepository<OfficialPosting, Long> {

    @Query("""
        SELECT op FROM OfficialPosting op
        JOIN FETCH op.official
        WHERE op.department.id = :departmentId
        AND op.startDate <= :asOfDate
        AND (op.endDate IS NULL OR op.endDate >= :asOfDate)
        ORDER BY op.startDate DESC
        """)
    List<OfficialPosting> findActivePostings(
            @Param("departmentId") Long departmentId,
            @Param("asOfDate") LocalDate asOfDate
    );

    List<OfficialPosting> findByDepartment_IdOrderByStartDateDesc(Long departmentId);

    default List<OfficialPosting> findCurrentPostings(Long departmentId) {
        return findActivePostings(departmentId, LocalDate.now());
    }
}