CREATE TABLE news_articles (
                               id BIGSERIAL PRIMARY KEY,
                               title VARCHAR(500) NOT NULL,
                               description TEXT,
                               content TEXT,
                               source_name VARCHAR(200),
                               source_url VARCHAR(500),
                               image_url VARCHAR(500),
                               category VARCHAR(100),
                               country VARCHAR(10),
                               language VARCHAR(10),
                               published_at TIMESTAMP,
                               article_id VARCHAR(200) UNIQUE,
                               tags TEXT[],
                               created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_news_published_at ON news_articles(published_at DESC);
CREATE INDEX idx_news_category ON news_articles(category);