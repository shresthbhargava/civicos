-- Acts and Laws table
CREATE TABLE acts (
                      id BIGSERIAL PRIMARY KEY,
                      name VARCHAR(255) NOT NULL,
                      short_name VARCHAR(100),
                      year INTEGER,
                      description TEXT,
                      governing_department_id BIGINT REFERENCES departments(id),
                      official_url VARCHAR(500),
                      active BOOLEAN DEFAULT true,
                      created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Link acts to incident categories
CREATE TABLE incident_category_acts (
                                        incident_category_id BIGINT REFERENCES incident_categories(id),
                                        act_id BIGINT REFERENCES acts(id),
                                        PRIMARY KEY (incident_category_id, act_id)
);

-- Seed real acts
INSERT INTO acts (name, short_name, year, description, governing_department_id, official_url)
VALUES
    (
        'Food Safety and Standards Act',
        'FSSA',
        2006,
        'Regulates food safety and standards in India. Citizens can file complaints about unsafe food, misleading labels, or adulterated products.',
        (SELECT id FROM departments WHERE code = 'NTA_CENTRAL' LIMIT 1),
    'https://fssai.gov.in'
    ),
(
    'Right to Information Act',
    'RTI',
    2005,
    'Gives every citizen the right to request information from any public authority. File an RTI to get details on any government decision or action.',
    (SELECT id FROM departments WHERE code = 'MIN_EDUCATION_CENTRAL' LIMIT 1),
    'https://rtionline.gov.in'
),
(
    'National Water Policy',
    'NWP',
    2012,
    'Governs water resource management and supply standards. Citizens can cite this policy when filing complaints about water quality or supply failures.',
    (SELECT id FROM departments WHERE code = 'WATER_STATE_MH' LIMIT 1),
    'https://jal.gov.in'
);