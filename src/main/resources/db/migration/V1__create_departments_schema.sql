-- Departments: The core accountability unit in CivicOS
-- A department can have a parent department, forming a hierarchy
-- Example: District Collector Office -> State Revenue Dept -> Ministry of Finance

CREATE TABLE departments (
                             id                  BIGSERIAL PRIMARY KEY,
                             name                VARCHAR(255) NOT NULL,
                             code                VARCHAR(100) NOT NULL UNIQUE,
                             description         TEXT,
                             jurisdiction_level  VARCHAR(50) NOT NULL,
                             jurisdiction_value  VARCHAR(255),
                             parent_department_id BIGINT REFERENCES departments(id),
                             ministry            VARCHAR(255),
                             website_url         VARCHAR(500),
                             contact_email       VARCHAR(255),
                             is_active           BOOLEAN NOT NULL DEFAULT TRUE,
                             created_at          TIMESTAMPTZ NOT NULL DEFAULT NOW(),
                             updated_at          TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_departments_code ON departments(code);
CREATE INDEX idx_departments_jurisdiction ON departments(jurisdiction_level, jurisdiction_value);
CREATE INDEX idx_departments_parent ON departments(parent_department_id);

COMMENT ON TABLE departments IS 'Government departments and agencies at all jurisdiction levels';
COMMENT ON COLUMN departments.code IS 'Unique machine-readable identifier, e.g. MIN_EDUCATION_CENTRAL';
COMMENT ON COLUMN departments.jurisdiction_level IS 'CENTRAL, STATE, DISTRICT, or LOCAL';
COMMENT ON COLUMN departments.jurisdiction_value IS 'State name or district name when applicable';
COMMENT ON COLUMN departments.parent_department_id IS 'Self-referential FK forming the accountability hierarchy';