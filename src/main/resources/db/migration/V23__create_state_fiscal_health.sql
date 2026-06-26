CREATE TABLE IF NOT EXISTS state_fiscal_health (
                                                   id BIGSERIAL PRIMARY KEY,
                                                   state_code VARCHAR(10) NOT NULL,
    state_name VARCHAR(100) NOT NULL,
    financial_year VARCHAR(10) NOT NULL,
    total_debt_cr BIGINT NOT NULL,
    revenue_receipts_cr BIGINT NOT NULL,
    revenue_expenditure_cr BIGINT NOT NULL,
    fiscal_deficit_cr BIGINT NOT NULL,
    debt_to_gdp_ratio DECIMAL(5,2),
    revenue_surplus_deficit_cr BIGINT,
    outstanding_liabilities_cr BIGINT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    UNIQUE(state_code, financial_year)
    );

CREATE INDEX idx_state_fiscal_state ON state_fiscal_health(state_code);
CREATE INDEX idx_state_fiscal_year ON state_fiscal_health(financial_year);

-- Seed with FY 2023-24 data (real approximate figures in crores)
INSERT INTO state_fiscal_health (state_code, state_name, financial_year, total_debt_cr, revenue_receipts_cr, revenue_expenditure_cr, fiscal_deficit_cr, debt_to_gdp_ratio, revenue_surplus_deficit_cr) VALUES
                                                                                                                                                                                                           ('MH', 'Maharashtra', '2023-24', 738000, 450000, 430000, 78000, 18.5, 20000),
                                                                                                                                                                                                           ('DL', 'Delhi', '2023-24', 72000, 85000, 78000, 18000, 9.2, 7000),
                                                                                                                                                                                                           ('KA', 'Karnataka', '2023-24', 520000, 310000, 295000, 55000, 21.3, 15000),
                                                                                                                                                                                                           ('TN', 'Tamil Nadu', '2023-24', 610000, 280000, 310000, 72000, 24.1, -30000),
                                                                                                                                                                                                           ('GJ', 'Gujarat', '2023-24', 340000, 270000, 250000, 35000, 15.8, 20000),
                                                                                                                                                                                                           ('UP', 'Uttar Pradesh', '2023-24', 780000, 380000, 405000, 95000, 22.7, -25000),
                                                                                                                                                                                                           ('RJ', 'Rajasthan', '2023-24', 480000, 210000, 230000, 68000, 28.4, -20000),
                                                                                                                                                                                                           ('WB', 'West Bengal', '2023-24', 540000, 230000, 260000, 58000, 27.9, -30000),
                                                                                                                                                                                                           ('MP', 'Madhya Pradesh', '2023-24', 380000, 190000, 200000, 45000, 24.6, -10000),
                                                                                                                                                                                                           ('KL', 'Kerala', '2023-24', 420000, 160000, 195000, 52000, 32.1, -35000),
                                                                                                                                                                                                           ('PB', 'Punjab', '2023-24', 350000, 130000, 155000, 48000, 38.2, -25000),
                                                                                                                                                                                                           ('HR', 'Haryana', '2023-24', 165000, 120000, 118000, 22000, 17.5, 2000),
                                                                                                                                                                                                           ('TG', 'Telangana', '2023-24', 290000, 200000, 185000, 38000, 19.8, 15000),
                                                                                                                                                                                                           ('AP', 'Andhra Pradesh', '2023-24', 440000, 195000, 210000, 52000, 26.3, -15000),
                                                                                                                                                                                                           ('OD', 'Odisha', '2023-24', 175000, 140000, 128000, 25000, 16.2, 12000),
                                                                                                                                                                                                           ('BH', 'Bihar', '2023-24', 210000, 135000, 150000, 42000, 23.8, -15000);