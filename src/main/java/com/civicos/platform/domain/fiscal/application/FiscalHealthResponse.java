package com.civicos.platform.domain.fiscal.application;
import com.civicos.platform.domain.fiscal.domain.StateFiscalHealth;
import lombok.*;

import java.math.BigDecimal;

@Getter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class FiscalHealthResponse {
    private String stateCode;
    private String stateName;
    private String financialYear;
    private Long totalDebtCr;
    private Long revenueReceiptsCr;
    private Long revenueExpenditureCr;
    private Long fiscalDeficitCr;
    private BigDecimal debtToGdpRatio;
    private Long revenueSurplusDeficitCr;
    private String fiscalHealthGrade; // A+, A, B, C, D based on debt-to-GDP

    public static FiscalHealthResponse from(StateFiscalHealth entity) {
        return FiscalHealthResponse.builder()
                .stateCode(entity.getStateCode())
                .stateName(entity.getStateName())
                .financialYear(entity.getFinancialYear())
                .totalDebtCr(entity.getTotalDebtCr())
                .revenueReceiptsCr(entity.getRevenueReceiptsCr())
                .revenueExpenditureCr(entity.getRevenueExpenditureCr())
                .fiscalDeficitCr(entity.getFiscalDeficitCr())
                .debtToGdpRatio(entity.getDebtToGdpRatio())
                .revenueSurplusDeficitCr(entity.getRevenueSurplusDeficitCr())
                .fiscalHealthGrade(calculateGrade(entity.getDebtToGdpRatio()))
                .build();
    }

    private static String calculateGrade(BigDecimal debtToGdp) {
        if (debtToGdp == null) return "N/A";
        double ratio = debtToGdp.doubleValue();
        if (ratio <= 15) return "A+";
        if (ratio <= 20) return "A";
        if (ratio <= 25) return "B";
        if (ratio <= 30) return "C";
        return "D";
    }
}