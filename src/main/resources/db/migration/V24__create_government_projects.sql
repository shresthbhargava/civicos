CREATE TABLE IF NOT EXISTS government_projects (
                                                   id BIGSERIAL PRIMARY KEY,
                                                   name VARCHAR(300) NOT NULL,
    slug VARCHAR(100) NOT NULL UNIQUE,
    description TEXT NOT NULL,
    department_code VARCHAR(50) NOT NULL,
    ministry VARCHAR(200),
    status VARCHAR(30) NOT NULL DEFAULT 'IN_PROGRESS',
    total_budget_cr BIGINT NOT NULL,
    spent_cr BIGINT NOT NULL DEFAULT 0,
    start_date DATE,
    target_completion_date DATE,
    actual_completion_date DATE,
    state_code VARCHAR(10),
    implementing_agency VARCHAR(200),
    category VARCHAR(50) NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT chk_project_status CHECK (status IN ('ANNOUNCED','IN_PROGRESS','COMPLETED','DELAYED','STALLED'))
    );

CREATE INDEX idx_projects_status ON government_projects(status);
CREATE INDEX idx_projects_department ON government_projects(department_code);
CREATE INDEX idx_projects_category ON government_projects(category);

COMMENT ON TABLE government_projects IS 'Tracks major government infrastructure and welfare projects';
COMMENT ON COLUMN government_projects.slug IS 'URL-friendly identifier e.g. delhi-metro-phase-4';

INSERT INTO government_projects (name, slug, description, department_code, ministry, status, total_budget_cr, spent_cr, start_date, target_completion_date, state_code, implementing_agency, category) VALUES
                                                                                                                                                                                                           ('Delhi Metro Phase IV', 'delhi-metro-phase-4', 'Extension of Delhi Metro network with 6 new lines covering 103.93 km with 62 stations across Delhi-NCR', 'MIN_HOUSING_CENTRAL', 'Ministry of Housing and Urban Affairs', 'IN_PROGRESS', 56900, 18500, '2022-01-01', '2026-03-31', 'DL', 'Delhi Metro Rail Corporation', 'INFRASTRUCTURE'),

                                                                                                                                                                                                           ('Bharatmala Pariyojana Phase I', 'bharatmala-phase-1', 'Largest highways infrastructure program covering 34,800 km of national highway corridors, economic corridors, and feeder routes', 'MORTH_CENTRAL', 'Ministry of Road Transport and Highways', 'IN_PROGRESS', 1080000, 420000, '2017-01-01', '2027-12-31', NULL, 'NHAI', 'INFRASTRUCTURE'),

                                                                                                                                                                                                           ('Smart Cities Mission', 'smart-cities-mission', 'Urban renewal and retrofitting program for 100 selected cities with focus on core infrastructure, clean environment, and smart solutions', 'MIN_HOUSING_CENTRAL', 'Ministry of Housing and Urban Affairs', 'IN_PROGRESS', 48000, 35200, '2015-06-25', '2025-06-25', NULL, 'MoHUA / State Governments', 'URBAN_DEVELOPMENT'),

                                                                                                                                                                                                           ('Jal Jeevan Mission', 'jal-jeevan-mission', 'Ensures functional household tap connection to every rural household across India, covering 19.3 crore rural households', 'MIN_RURAL_CENTRAL', 'Ministry of Jal Shakti', 'IN_PROGRESS', 360000, 240000, '2019-08-15', '2024-12-31', NULL, 'State Water and Sanitation Missions', 'WATER_SANITATION'),

                                                                                                                                                                                                           ('PM GatiShakti National Master Plan', 'pm-gatishakti', 'Digital platform integrating 16 ministries for coordinated infrastructure planning, multimodal connectivity, and logistics efficiency', 'DOT_CENTRAL', 'Ministry of Commerce and Industry', 'IN_PROGRESS', 1110000, 380000, '2021-10-13', '2027-03-31', NULL, 'DPIIT', 'DIGITAL_INFRA'),

                                                                                                                                                                                                           ('Swachh Bharat Mission Urban 2.0', 'swachh-bharat-urban-2', 'Phase 2 focusing on all statutory towns for sustainable sanitation, waste processing, and making cities garbage-free', 'MIN_HOUSING_CENTRAL', 'Ministry of Housing and Urban Affairs', 'IN_PROGRESS', 14000, 8500, '2021-10-01', '2026-10-01', NULL, 'MoHUA / Municipal Corporations', 'SANITATION'),

                                                                                                                                                                                                           ('National Education Policy 2020 Implementation', 'nep-2020-implementation', 'Overhaul of school and higher education including multidisciplinary universities, vocational training integration, and digital learning', 'MIN_EDUCATION_CENTRAL', 'Ministry of Education', 'IN_PROGRESS', 85000, 22000, '2020-07-29', '2030-07-29', NULL, 'NCERT / UGC / AICTE', 'EDUCATION'),

                                                                                                                                                                                                           ('PM Ayushman Bharat Health Infrastructure Mission', 'pm-abyhim', 'Strengthening public health infrastructure with AIIMS, district hospitals, block public health units, and critical care networks', 'MIN_HEALTH_CENTRAL', 'Ministry of Health and Family Welfare', 'IN_PROGRESS', 64180, 18500, '2021-10-25', '2026-03-31', NULL, 'Ministry of Health / State Govts', 'HEALTHCARE'),

                                                                                                                                                                                                           ('Ujjwala 2.0 - LPG Connection Expansion', 'ujjwala-2', 'Providing additional LPG connections to poor households and migrating existing users to regular refills under PMUY scheme', 'MIN_POWER_CENTRAL', 'Ministry of Petroleum and Natural Gas', 'IN_PROGRESS', 2100, 1800, '2021-05-14', '2025-12-31', NULL, 'Oil Marketing Companies', 'WELFARE'),

                                                                                                                                                                                                           ('Semiconductor India Programme', 'india-semiconductor-mission', 'Building semiconductor fabrication and display manufacturing ecosystem with Rs 76,000 crore incentive scheme for chip manufacturing', 'MEITY_CENTRAL', 'Ministry of Electronics and IT', 'IN_PROGRESS', 76000, 8500, '2021-12-21', '2028-12-31', NULL, 'India Semiconductor Mission', 'TECHNOLOGY');