package com.civicos.platform.domain.complaint.domain;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface ComplaintRepository extends JpaRepository<Complaint, Long> {

    Optional<Complaint> findByTrackingId(String trackingId);

    Page<Complaint> findByDepartmentId(Long departmentId, Pageable pageable);

    Page<Complaint> findByStatus(Complaint.ComplaintStatus status, Pageable pageable);

    @Query("SELECT COUNT(c) FROM Complaint c WHERE c.status = :status")
    long countByStatus(@Param("status") Complaint.ComplaintStatus status);

    @Query("SELECT c.status, COUNT(c) FROM Complaint c GROUP BY c.status")
    Object[][] countByAllStatuses();
}
