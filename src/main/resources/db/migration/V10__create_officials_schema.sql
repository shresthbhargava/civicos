-- Enable btree_gist extension required for exclusion constraints on non-geometric types
CREATE EXTENSION IF NOT EXISTS btree_gist;

CREATE TABLE officials (
                           id              BIGSERIAL PRIMARY KEY,
                           full_name       VARCHAR(255) NOT NULL,
                           officer_code    VARCHAR(100) NOT NULL UNIQUE,
                           rank            VARCHAR(100),
                           cadre           VARCHAR(100),
                           contact_email   VARCHAR(255),
                           created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
                           updated_at      TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE official_postings (
                                   id              BIGSERIAL PRIMARY KEY,
                                   official_id     BIGINT NOT NULL REFERENCES officials(id),
                                   department_id   BIGINT NOT NULL REFERENCES departments(id),
                                   posting_title   VARCHAR(255) NOT NULL,
                                   start_date      DATE NOT NULL,
                                   end_date        DATE,
                                   source_url      VARCHAR(500),
                                   created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
                                   updated_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),

                                   CONSTRAINT chk_posting_dates
                                       CHECK (end_date IS NULL OR end_date > start_date),

                                   EXCLUDE USING gist (
        department_id WITH =,
        daterange(start_date, COALESCE(end_date, '9999-12-31'::date), '[]') WITH &&
    )
);

CREATE INDEX idx_postings_department_current
    ON official_postings(department_id, start_date, end_date);

CREATE INDEX idx_postings_official
    ON official_postings(official_id);

COMMENT ON TABLE officials IS
    'Individual government officers. Separate from postings to support transfer history.';

COMMENT ON TABLE official_postings IS
    'Temporal record of officer-to-department assignments. end_date NULL means currently active.';

COMMENT ON COLUMN official_postings.end_date IS
    'NULL indicates active posting. Set to transfer/retirement date when posting ends.';