package com.civicos.platform.domain.complaint.application;

import com.civicos.platform.common.exception.CivicOSException;
import com.civicos.platform.common.exception.ErrorCode;
import com.civicos.platform.domain.complaint.domain.Complaint;
import com.civicos.platform.domain.complaint.domain.ComplaintRepository;
import com.civicos.platform.domain.department.domain.Department;
import com.civicos.platform.domain.department.domain.DepartmentRepository;
import com.civicos.platform.domain.incident.domain.IncidentCategory;
import com.civicos.platform.domain.incident.domain.IncidentCategoryRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Lazy;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import java.time.Instant;
import java.time.Year;
import java.util.Set;
import java.util.concurrent.atomic.AtomicLong;


@Slf4j
@Service
@RequiredArgsConstructor
public class ComplaintService {

    private static final Set<String> VALID_TRANSITIONS = Set.of(
            "SUBMITTED->ACKNOWLEDGED",
            "SUBMITTED->REJECTED",
            "ACKNOWLEDGED->IN_PROGRESS",
            "IN_PROGRESS->RESOLVED",
            "IN_PROGRESS->REJECTED"
    );

    private final ComplaintRepository complaintRepository;
    private final DepartmentRepository departmentRepository;
    private final IncidentCategoryRepository incidentCategoryRepository;
    private final AtomicLong sequenceCounter = new AtomicLong(0);

    @Lazy
    @Autowired
    private ComplaintService self;

    @Transactional
    public ComplaintResponse fileComplaint(ComplaintRequest request, String categoryCode, String departmentCode) {
        IncidentCategory category = incidentCategoryRepository.findByCode(categoryCode)
                .orElseThrow(() -> new CivicOSException(ErrorCode.INCIDENT_NOT_FOUND, "Category not found: " + categoryCode));

        Department department = departmentRepository.findByCode(departmentCode)
                .orElseThrow(() -> new CivicOSException(ErrorCode.DEPARTMENT_NOT_FOUND, "Department not found: " + departmentCode));

        Complaint complaint = new Complaint();
        complaint.setTrackingId(generateTrackingId());
        complaint.setDepartment(department);
        complaint.setIncidentCategory(category);
        complaint.setDescription(request.getDescription());
        complaint.setCitizenName(request.getCitizenName());
        complaint.setCitizenEmail(request.getCitizenEmail());
        complaint.setStateCode(request.getStateCode());
        complaint.setDistrictCode(request.getDistrictCode());

        try {
            complaint = self.doSaveComplaint(complaint);
            log.info("Complaint filed: {} for category={} department={}", complaint.getTrackingId(), categoryCode, departmentCode);
        } catch (DataIntegrityViolationException e) {
            log.warn("Tracking ID collision, retrying with new ID");
            complaint.setTrackingId(generateTrackingId());
            complaint = self.doSaveComplaint(complaint);
            log.info("Complaint filed on retry: {} for category={} department={}", complaint.getTrackingId(), categoryCode, departmentCode);
        }

        return ComplaintResponse.from(complaint);
    }

    @Transactional(propagation = Propagation.REQUIRES_NEW)
    public Complaint doSaveComplaint(Complaint complaint) {
        return complaintRepository.save(complaint);
    }

    @Transactional(readOnly = true)
    public ComplaintResponse getByTrackingId(String trackingId) {
        Complaint complaint = complaintRepository.findByTrackingId(trackingId)
                .orElseThrow(() -> new CivicOSException(ErrorCode.COMPLAINT_NOT_FOUND, "Complaint not found: " + trackingId));
        return ComplaintResponse.from(complaint);
    }

    @Transactional(readOnly = true)
    public Page<ComplaintResponse> getByDepartment(String departmentCode, int page, int size) {
        Department department = departmentRepository.findByCode(departmentCode)
                .orElseThrow(() -> new CivicOSException(ErrorCode.DEPARTMENT_NOT_FOUND, "Department not found: " + departmentCode));
        return complaintRepository.findByDepartmentId(department.getId(), PageRequest.of(page, size))
                .map(ComplaintResponse::from);
    }

    @Transactional(readOnly = true)
    public Page<ComplaintResponse> getByStatus(String status, int page, int size) {
        Complaint.ComplaintStatus complaintStatus = Complaint.ComplaintStatus.valueOf(status.toUpperCase());
        return complaintRepository.findByStatus(complaintStatus, PageRequest.of(page, size))
                .map(ComplaintResponse::from);
    }

    @Transactional
    public ComplaintResponse updateStatus(String trackingId, String newStatus) {
        Complaint complaint = complaintRepository.findByTrackingId(trackingId)
                .orElseThrow(() -> new CivicOSException(ErrorCode.COMPLAINT_NOT_FOUND, "Complaint not found: " + trackingId));

        Complaint.ComplaintStatus targetStatus = Complaint.ComplaintStatus.valueOf(newStatus.toUpperCase());
        String transition = complaint.getStatus().name() + "->" + targetStatus.name();

        if (!VALID_TRANSITIONS.contains(transition)) {
            throw new CivicOSException(ErrorCode.INVALID_STATUS_TRANSITION,
                    "Cannot transition from " + complaint.getStatus() + " to " + targetStatus);
        }

        complaint.setStatus(targetStatus);

        switch (targetStatus) {
            case ACKNOWLEDGED -> complaint.setAcknowledgedAt(Instant.now());
            case RESOLVED, REJECTED -> complaint.setResolvedAt(Instant.now());
        }

        log.info("Complaint {} status: {} -> {}", trackingId, complaint.getStatus(), targetStatus);
        return ComplaintResponse.from(complaintRepository.save(complaint));
    }

    private String generateTrackingId() {
        int year = Year.now().getValue();
        long seq = sequenceCounter.incrementAndGet();
        return String.format("CIV-%d-%05d", year, seq);
    }
}