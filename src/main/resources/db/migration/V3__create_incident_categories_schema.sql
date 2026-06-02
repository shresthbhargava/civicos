-- Incident categories: Maps types of civic incidents to responsible departments
-- This is the core intelligence of CivicOS v1
-- When a citizen reports "exam leak", we look up which department is responsible

CREATE TABLE incident_categories (
                                     id                  BIGSERIAL PRIMARY KEY,
                                     name                VARCHAR(255) NOT NULL,
                                     code                VARCHAR(100) NOT NULL UNIQUE,
                                     description         TEXT,
                                     department_id       BIGINT NOT NULL REFERENCES departments(id),
                                     keywords            TEXT[],
                                     citizen_actions     TEXT[],
                                     created_at          TIMESTAMPTZ NOT NULL DEFAULT NOW(),
                                     updated_at          TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_incident_categories_department ON incident_categories(department_id);
CREATE INDEX idx_incident_categories_keywords ON incident_categories USING GIN(keywords);

COMMENT ON TABLE incident_categories IS 'Maps civic incident types to accountable departments';
COMMENT ON COLUMN incident_categories.keywords IS 'Array of searchable keywords for this incident type';
COMMENT ON COLUMN incident_categories.citizen_actions IS 'Array of actions a citizen can take for this incident type';