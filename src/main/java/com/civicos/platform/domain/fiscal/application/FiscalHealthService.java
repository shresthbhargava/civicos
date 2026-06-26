package com.civicos.platform.domain.fiscal.application;

import com.civicos.platform.domain.fiscal.domain.StateFiscalHealth;
import com.civicos.platform.domain.fiscal.domain.StateFiscalHealthRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@RequiredArgsConstructor
public class FiscalHealthService {

    private final StateFiscalHealthRepository repository;

    @Transactional(readOnly = true)
    public List<FiscalHealthResponse> getLatestFiscalHealth() {
        return repository.findLatestYearData().stream()
                .map(FiscalHealthResponse::from)
                .toList();
    }

    @Transactional(readOnly = true)
    public FiscalHealthResponse getByState(String stateCode) {
        List<FiscalHealthResponse> latest = getLatestFiscalHealth();
        return latest.stream()
                .filter(r -> r.getStateCode().equals(stateCode))
                .findFirst()
                .orElse(null);
    }
}