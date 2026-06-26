CREATE TABLE IF NOT EXISTS complaints (
    id BIGSERIAL PRIMARY KEY,
    tracking_id VARCHAR(20) NOT NULL UNIQUE,
    department_id BIGINT NOT NULL REFERENCES departments(id),
    incident_category_id BIGINT NOT NULL REFERENCES incident_categories(id),
    status VARCHAR(30) NOT NULL DEFAULT 'SUBMITTED',
    description TEXT NOT NULL,
    citizen_email VARCHAR(255),
    citizen_name VARCHAR(255),
    state_code VARCHAR(10),
    district_code VARCHAR(20),
    resolution_notes TEXT,
    acknowledged_at TIMESTAMPTZ,
    resolved_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT chk_complaint_status CHECK (status IN ('SUBMITTED','ACKNOWLEDGED','IN_PROGRESS','RESOLVED','REJECTED'))
);

CREATE INDEX idx_complaints_tracking_id ON complaints(tracking_id);
CREATE INDEX idx_complaints_department_id ON complaints(department_id);
CREATE INDEX idx_complaints_status ON complaints(status);
CREATE INDEX idx_complaints_category_id ON complaints(incident_category_id);

COMMENT ON TABLE complaints IS 'Citizen complaints filed against government departments';
COMMENT ON COLUMN complaints.tracking_id IS 'Human-readable tracking ID e.g. CIV-2026-00001';
COMMENT ON COLUMN complaints.status IS 'Workflow: SUBMITTED → ACKNOWLEDGED → IN_PROGRESS → RESOLVED/REJECTED';
