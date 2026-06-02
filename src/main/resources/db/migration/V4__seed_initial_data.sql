-- Seed data: Real Indian government departments relevant to CivicOS v1
-- Source: Official government websites
-- This gives us real data to work with from day one

INSERT INTO departments (name, code, description, jurisdiction_level, ministry) VALUES
                                                                                    (
                                                                                        'Ministry of Education',
                                                                                        'MIN_EDUCATION_CENTRAL',
                                                                                        'Central ministry responsible for national education policy, higher education regulation, and coordination with state education departments',
                                                                                        'CENTRAL',
                                                                                        'Ministry of Education'
                                                                                    ),
                                                                                    (
                                                                                        'National Testing Agency',
                                                                                        'NTA_CENTRAL',
                                                                                        'Autonomous organization under Ministry of Education responsible for conducting entrance examinations including JEE, NEET, CUET',
                                                                                        'CENTRAL',
                                                                                        'Ministry of Education'
                                                                                    ),
                                                                                    (
                                                                                        'University Grants Commission',
                                                                                        'UGC_CENTRAL',
                                                                                        'Statutory body under Ministry of Education that regulates university education and disburses funds',
                                                                                        'CENTRAL',
                                                                                        'Ministry of Education'
                                                                                    ),
                                                                                    (
                                                                                        'Ministry of Health and Family Welfare',
                                                                                        'MIN_HEALTH_CENTRAL',
                                                                                        'Central ministry responsible for national health policy, AIIMS, and health scheme implementation',
                                                                                        'CENTRAL',
                                                                                        'Ministry of Health and Family Welfare'
                                                                                    ),
                                                                                    (
                                                                                        'Ministry of Rural Development',
                                                                                        'MIN_RURAL_CENTRAL',
                                                                                        'Central ministry responsible for MGNREGA, PMAY-G, and rural infrastructure schemes',
                                                                                        'CENTRAL',
                                                                                        'Ministry of Rural Development'
                                                                                    );

-- Set parent relationships
UPDATE departments
SET parent_department_id = (SELECT id FROM departments WHERE code = 'MIN_EDUCATION_CENTRAL')
WHERE code IN ('NTA_CENTRAL', 'UGC_CENTRAL');

-- Seed incident categories
INSERT INTO incident_categories (name, code, description, department_id, keywords, citizen_actions) VALUES
                                                                                                        (
                                                                                                            'Examination Irregularity',
                                                                                                            'EXAM_IRREGULARITY',
                                                                                                            'Covers exam leaks, malpractice, paper irregularities in centrally conducted examinations',
                                                                                                            (SELECT id FROM departments WHERE code = 'NTA_CENTRAL'),
                                                                                                            ARRAY['exam leak', 'paper leak', 'malpractice', 'exam irregularity', 'question paper', 'nptel', 'jee', 'neet', 'cuet'],
                                                                                                            ARRAY[
                                                                                                                'File a complaint at nta.ac.in/complaint',
                                                                                                            'Submit RTI request to NTA for exam process details',
                                                                                                            'Contact Ministry of Education grievance portal at pgportal.gov.in',
                                                                                                            'Approach Central Information Commission if RTI is denied'
                                                                                                                ]
                                                                                                        ),
                                                                                                        (
                                                                                                            'University Funding Dispute',
                                                                                                            'UNIVERSITY_FUNDING',
                                                                                                            'Issues related to university grants, scholarship disbursement, and UGC regulation',
                                                                                                            (SELECT id FROM departments WHERE code = 'UGC_CENTRAL'),
                                                                                                            ARRAY['scholarship', 'ugc', 'university grant', 'fellowship', 'stipend', 'research funding'],
                                                                                                            ARRAY[
                                                                                                                'File grievance at ugc.ac.in',
                                                                                                            'Contact UGC helpline',
                                                                                                            'Submit RTI to UGC for funding details'
                                                                                                                ]
                                                                                                        );