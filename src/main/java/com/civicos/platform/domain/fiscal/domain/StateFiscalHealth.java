package com.civicos.platform.domain.fiscal.domain;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import java.math.BigDecimal;
import java.time.Instant;

@Entity
@Table(name = "state_fiscal_health")
@Getter
@Setter
@NoArgsConstructor
public class StateFiscalHealth {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "state_code", nullable = false, length = 10)
    private String stateCode;

    @Column(name = "state_name", nullable = false, length = 100)
    private String stateName;

    @Column(name = "financial_year", nullable = false, length = 10)
    private String financialYear;

    @Column(name = "total_debt_cr", nullable = false)
    private Long totalDebtCr;

    @Column(name = "revenue_receipts_cr", nullable = false)
    private Long revenueReceiptsCr;

    @Column(name = "revenue_expenditure_cr", nullable = false)
    private Long revenueExpenditureCr;

    @Column(name = "fiscal_deficit_cr", nullable = false)
    private Long fiscalDeficitCr;

    @Column(name = "debt_to_gdp_ratio", precision = 5, scale = 2)
    private BigDecimal debtToGdpRatio;

    @Column(name = "revenue_surplus_deficit_cr")
    private Long revenueSurplusDeficitCr;

    @Column(name = "outstanding_liabilities_cr")
    private Long outstandingLiabilitiesCr;

    @Column(name = "created_at", nullable = false, updatable = false)
    private Instant createdAt;

    @Column(name = "updated_at", nullable = false)
    private Instant updatedAt;

    @PrePersist
    protected void onCreate() { createdAt = Instant.now(); updatedAt = Instant.now(); }
    @PreUpdate
    protected void onUpdate() { updatedAt = Instant.now(); }
}