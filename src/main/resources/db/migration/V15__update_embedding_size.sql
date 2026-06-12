ALTER TABLE incident_categories
DROP COLUMN IF EXISTS embedding;

ALTER TABLE incident_categories
    ADD COLUMN embedding vector(768);

DROP INDEX IF EXISTS idx_incident_categories_embedding;

CREATE INDEX idx_incident_categories_embedding
    ON incident_categories
    USING ivfflat (embedding vector_cosine_ops)
    WITH (lists = 10);