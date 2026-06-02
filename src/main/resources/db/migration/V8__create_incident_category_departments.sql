-- Junction table for location-specific department mappings
-- incident_categories.department_id remains as the default/central fallback
-- This table provides location-specific overrides

CREATE TABLE incident_category_departments (
                                               id                      BIGSERIAL PRIMARY KEY,
                                               incident_category_id    BIGINT NOT NULL REFERENCES incident_categories(id),
                                               department_id           BIGINT NOT NULL REFERENCES departments(id),
                                               responsibility_level    VARCHAR(50) NOT NULL,
                                               created_at              TIMESTAMPTZ NOT NULL DEFAULT NOW(),

                                               CONSTRAINT uq_category_department
                                                   UNIQUE (incident_category_id, department_id)
);

CREATE INDEX idx_icd_category ON incident_category_departments(incident_category_id);
CREATE INDEX idx_icd_department ON incident_category_departments(department_id);

COMMENT ON TABLE incident_category_departments IS
    'Location-specific department mappings for incident categories.
     Use incident_categories.department_id for central/default fallback.';

COMMENT ON COLUMN incident_category_departments.responsibility_level IS
    'PRIMARY = directly responsible, ESCALATION = escalate if primary unresponsive';