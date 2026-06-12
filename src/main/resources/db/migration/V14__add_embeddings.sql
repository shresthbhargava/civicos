-- Add vector extension
CREATE EXTENSION IF NOT EXISTS vector;

-- Add embedding column to incident_categories
ALTER TABLE incident_categories
    ADD COLUMN IF NOT EXISTS embedding vector(1536);

-- Create index for fast cosine similarity search
CREATE INDEX IF NOT EXISTS idx_incident_categories_embedding
    ON incident_categories
    USING ivfflat (embedding vector_cosine_ops)
    WITH (lists = 10);