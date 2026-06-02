package com.civicos.platform.domain.department.application;

import com.civicos.platform.domain.department.domain.DepartmentRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

@Slf4j
@Service
@RequiredArgsConstructor
public class AccountabilityService {

    private final DepartmentRepository departmentRepository;

    @Transactional(readOnly = true)
    public List<AccountabilityNode> getChain(Long departmentId) {
        log.debug("Fetching accountability chain for departmentId={}", departmentId);

        List<Object[]> rows = departmentRepository
                .findAccountabilityChain(departmentId);

        return rows.stream()
                .map(row -> AccountabilityNode.builder()
                        .id(((Number) row[0]).longValue())
                        .name((String) row[1])
                        .code((String) row[2])
                        .jurisdictionLevel((String) row[3])
                        .ministry((String) row[5])
                        .depth(((Number) row[6]).intValue())
                        .build()
                )
                .collect(Collectors.toList());
    }
}