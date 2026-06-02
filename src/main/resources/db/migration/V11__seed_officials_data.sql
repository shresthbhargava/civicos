INSERT INTO officials (full_name, officer_code, rank, cadre, contact_email)
VALUES
    (
        'Pradeep Singh Kharola',
        'OFF_NTA_DG_001',
        'Director General',
        'IAS',
        'dg@nta.ac.in'
    ),
    (
        'M. Jagadesh Kumar',
        'OFF_UGC_CHAIR_001',
        'Chairman',
        'Academic',
        'chairman@ugc.ac.in'
    ),
    (
        'Santosh Kumar Mall',
        'OFF_RURAL_SEC_001',
        'Secretary',
        'IAS',
        'secretary@rural.gov.in'
    );

INSERT INTO official_postings
(official_id, department_id, posting_title, start_date, end_date, source_url)
VALUES
    (
        (SELECT id FROM officials WHERE officer_code = 'OFF_NTA_DG_001'),
        (SELECT id FROM departments WHERE code = 'NTA_CENTRAL'),
        'Director General',
        '2024-01-15',
        NULL,
        'https://www.nta.ac.in/aboutnta'
    ),
    (
        (SELECT id FROM officials WHERE officer_code = 'OFF_UGC_CHAIR_001'),
        (SELECT id FROM departments WHERE code = 'UGC_CENTRAL'),
        'Chairman',
        '2022-02-07',
        NULL,
        'https://www.ugc.ac.in/about'
    ),
    (
        (SELECT id FROM officials WHERE officer_code = 'OFF_RURAL_SEC_001'),
        (SELECT id FROM departments WHERE code = 'MIN_RURAL_CENTRAL'),
        'Secretary',
        '2023-06-01',
        NULL,
        'https://rural.gov.in'
    );