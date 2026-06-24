CREATE TABLE daily_editions(
    id BIGSERIAL PRIMARY KEY,
    edition_date DATE NOT NULL UNIQUE,
    headline VARCHAR(500),
    stories JSONB NOT NULL DEFAULT '[]',
    generated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP



);
CREATE INDEX idx_daily_editions_date ON daily_editions(edition_date DESC);