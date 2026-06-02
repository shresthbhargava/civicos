package com.civicos.platform.domain.department.application;

import com.civicos.platform.domain.official.application.OfficialResponse;
import com.civicos.platform.domain.official.application.OfficialService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.util.List;

@Service
@RequiredArgsConstructor
public class DepartmentAccountabilityFacade {

    private final AccountabilityService accountabilityService;
    private final OfficialService officialService;

    public DepartmentAccountabilityContext getContext(Long departmentId) {
        List<AccountabilityNode> chain = accountabilityService.getChain(departmentId);
        List<OfficialResponse> officials = officialService.getOfficialsAsOf(departmentId, LocalDate.now());
        return new DepartmentAccountabilityContext(chain, officials);
    }
}