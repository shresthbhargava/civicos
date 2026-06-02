-- State-level departments for Maharashtra
INSERT INTO departments (name, code, description, jurisdiction_level, jurisdiction_value, ministry, website_url, is_active)
VALUES
    (
        'Maharashtra Water Supply and Sanitation Department',
        'WATER_STATE_MH',
        'State department responsible for water supply schemes, rural water infrastructure, and sanitation across Maharashtra',
        'STATE',
        'MH',
        'Water Supply and Sanitation Department, Maharashtra',
        'https://www.maharashtra.gov.in',
        true
    ),
    (
        'Maharashtra State Board of Secondary and Higher Secondary Education',
        'EDUCATION_BOARD_STATE_MH',
        'Conducts SSC and HSC examinations across Maharashtra. Responsible for exam integrity and result declaration',
        'STATE',
        'MH',
        'School Education and Sports Department, Maharashtra',
        'https://mahahsscboard.in',
        true
    ),
    (
        'Maharashtra Public Works Department',
        'PWD_STATE_MH',
        'Responsible for construction and maintenance of state highways, government buildings, and public infrastructure in Maharashtra',
        'STATE',
        'MH',
        'Public Works Department, Maharashtra',
        'https://pwd.maharashtra.gov.in',
        true
    );

-- State-level departments for Delhi
INSERT INTO departments (name, code, description, jurisdiction_level, jurisdiction_value, ministry, website_url, is_active)
VALUES
    (
        'Delhi Jal Board',
        'WATER_STATE_DL',
        'Responsible for water supply, sewerage infrastructure, and water quality across Delhi',
        'STATE',
        'DL',
        'Delhi Jal Board',
        'https://www.delhijalboard.in',
        true
    ),
    (
        'Directorate of Education Delhi',
        'EDUCATION_STATE_DL',
        'Governs government schools, teacher deployment, and education quality across Delhi',
        'STATE',
        'DL',
        'Education Department, Government of NCT of Delhi',
        'https://www.edudel.nic.in',
        true
    ),
    (
        'Public Works Department Delhi',
        'PWD_STATE_DL',
        'Responsible for road construction, maintenance, and public infrastructure in Delhi',
        'STATE',
        'DL',
        'Public Works Department, Delhi',
        'https://pwd.delhi.gov.in',
        true
    );

-- District-level departments
INSERT INTO departments (name, code, description, jurisdiction_level, jurisdiction_value, ministry, is_active)
VALUES
    (
        'Pune District Water Supply Office',
        'WATER_DISTRICT_MH_PUNE',
        'District office handling water supply complaints, tanker requests, and local water infrastructure for Pune district',
        'DISTRICT',
        'MH-PUNE',
        'Maharashtra Water Supply and Sanitation Department',
        true
    ),
    (
        'Mumbai District Water Supply Office',
        'WATER_DISTRICT_MH_MUMBAI',
        'District office for water supply, leakage complaints, and connection issues in Mumbai district',
        'DISTRICT',
        'MH-MUMBAI',
        'Maharashtra Water Supply and Sanitation Department',
        true
    );

-- Set parent relationships for state departments
UPDATE departments
SET parent_department_id = (
    SELECT id FROM departments WHERE code = 'MIN_RURAL_CENTRAL'
)
WHERE code IN ('WATER_STATE_MH', 'WATER_STATE_DL');

-- Set parent relationships for district departments
UPDATE departments
SET parent_department_id = (
    SELECT id FROM departments WHERE code = 'WATER_STATE_MH'
)
WHERE code IN ('WATER_DISTRICT_MH_PUNE', 'WATER_DISTRICT_MH_MUMBAI');