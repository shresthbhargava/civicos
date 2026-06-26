package com.civicos.platform.domain.official.application;

import com.civicos.platform.domain.official.domain.OfficialPosting;
import com.civicos.platform.domain.official.domain.OfficialPostingRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.util.List;
import java.util.stream.Collectors;
import org.springframework.cache.annotation.Cacheable;

@Slf4j
@Service
@RequiredArgsConstructor
public class OfficialService {

    public List<OfficialResponse> getPostingHistory(Long departmentId) {
        return officialPostingRepository
                .findByDepartment_IdOrderByStartDateDesc(departmentId)
                .stream()
                .map(OfficialResponse::from)
                .toList();
    }

    private final OfficialPostingRepository officialPostingRepository;

    @Transactional(readOnly = true)
    @Cacheable(value = "current-officials", key = "#departmentId")
    public List<OfficialResponse> getCurrentOfficials(Long departmentId) {
        log.debug("Fetching current officials for departmentId={}", departmentId);

        List<OfficialPosting> postings =
                officialPostingRepository.findCurrentPostings(departmentId);

        return postings.stream()
                .map(OfficialResponse::from)
                .collect(Collectors.toList());
    }

    @Transactional(readOnly = true)
    public List<OfficialResponse> getOfficialsAsOf(
            Long departmentId, LocalDate asOfDate) {

        log.debug("Fetching officials for departmentId={} asOf={}",
                departmentId, asOfDate);

        List<OfficialPosting> postings =
                officialPostingRepository.findActivePostings(departmentId, asOfDate);

        return postings.stream()
                .map(OfficialResponse::from)
                .collect(Collectors.toList());
    }
}