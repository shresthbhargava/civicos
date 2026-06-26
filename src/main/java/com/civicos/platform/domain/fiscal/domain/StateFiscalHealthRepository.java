package com.civicos.platform.domain.fiscal.domain;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import java.util.List;
import java.util.Optional;

@Repository
public interface StateFiscalHealthRepository extends JpaRepository<StateFiscalHealth, Long> {

    Optional<StateFiscalHealth> findByStateCodeAndFinancialYear(String stateCode, String financialYear);

    List<StateFiscalHealth> findByFinancialYearOrderByDebtToGdpRatioDesc(String financialYear);

    @Query("SELECT s FROM StateFiscalHealth s WHERE s.financialYear = " +
            "(SELECT MAX(s2.financialYear) FROM StateFiscalHealth s2) " +
            "ORDER BY s.debtToGdpRatio DESC")
    List<StateFiscalHealth> findLatestYearData();
}