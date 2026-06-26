INSERT INTO acts (name, short_name, year, description, governing_department_id, official_url) VALUES
                                                                                                  ('Consumer Protection Act', 'CPA', 2019, 'Consumer rights, dispute resolution, compensation for defective goods and services', (SELECT id FROM departments WHERE code = 'MIN_CONSUMER_CENTRAL'), 'https://consumeraffairs.gov.in'),
                                                                                                  ('Information Technology Act', 'ITA', 2000, 'Cyber crime, digital signatures, data protection, electronic commerce', (SELECT id FROM departments WHERE code = 'MEITY_CENTRAL'), 'https://meity.gov.in'),
                                                                                                  ('Environment Protection Act', 'EPA', 1986, 'Environmental protection framework, pollution control, hazardous waste', (SELECT id FROM departments WHERE code = 'MIN_ENVIRONMENT_CENTRAL'), 'https://moefcc.gov.in'),
                                                                                                  ('Electricity Act', 'EA', 2003, 'Generation, transmission, distribution, and trading of electricity', (SELECT id FROM departments WHERE code = 'MIN_POWER_CENTRAL'), 'https://powermin.gov.in'),
                                                                                                  ('Real Estate Regulation and Development Act', 'RERA', 2016, 'Protects home buyers from builder delays, ensures real estate transparency', (SELECT id FROM departments WHERE code = 'MIN_HOUSING_CENTRAL'), 'https://mohua.gov.in'),
                                                                                                  ('Air Prevention and Control of Pollution Act', 'APCPA', 1981, 'Air pollution prevention, establishes central and state pollution control boards', (SELECT id FROM departments WHERE code = 'MIN_ENVIRONMENT_CENTRAL'), 'https://cpcb.nic.in'),
                                                                                                  ('Employees Provident Funds Act', 'EPFA', 1952, 'Provident fund, pension, and insurance for organized sector workers', (SELECT id FROM departments WHERE code = 'MIN_LABOUR_CENTRAL'), 'https://epfindia.gov.in'),
                                                                                                  ('Prevention of Corruption Act', 'PCA', 1988, 'Corruption offences, penalties for public servants, investigative powers', (SELECT id FROM departments WHERE code = 'CVC_CENTRAL'), 'https://cvc.gov.in'),
                                                                                                  ('Right to Education Act', 'RTE', 2009, 'Free and compulsory education for children aged 6-14, school infrastructure standards', (SELECT id FROM departments WHERE code = 'MIN_EDUCATION_CENTRAL'), 'https://education.gov.in'),
                                                                                                  ('National Food Security Act', 'NFSA', 2013, 'Food and nutritional security, covers TPDS and ICDS', (SELECT id FROM departments WHERE code = 'FSSAI_CENTRAL'), 'https://fssai.gov.in');

INSERT INTO incident_category_acts (incident_category_id, act_id)
SELECT ic.id, a.id FROM incident_categories ic, acts a WHERE ic.code = 'EXAM_IRREGULARITY' AND a.short_name = 'RTE'
    ON CONFLICT DO NOTHING;

INSERT INTO incident_category_acts (incident_category_id, act_id)
SELECT ic.id, a.id FROM incident_categories ic, acts a WHERE ic.code = 'UNIVERSITY_FUNDING' AND a.short_name = 'RTE'
    ON CONFLICT DO NOTHING;

INSERT INTO incident_category_acts (incident_category_id, act_id)
SELECT ic.id, a.id FROM incident_categories ic, acts a WHERE ic.code = 'WATER_SUPPLY_FAILURE' AND a.short_name = 'EPA'
    ON CONFLICT DO NOTHING;

INSERT INTO incident_category_acts (incident_category_id, act_id)
SELECT ic.id, a.id FROM incident_categories ic, acts a WHERE ic.code = 'ROAD_DAMAGE' AND a.short_name = 'CPA'
    ON CONFLICT DO NOTHING;

INSERT INTO incident_category_acts (incident_category_id, act_id)
SELECT ic.id, a.id FROM incident_categories ic, acts a WHERE ic.code = 'POWER_FAILURE' AND a.short_name IN ('EA', 'CPA')
    ON CONFLICT DO NOTHING;

INSERT INTO incident_category_acts (incident_category_id, act_id)
SELECT ic.id, a.id FROM incident_categories ic, acts a WHERE ic.code = 'FOOD_SAFETY' AND a.short_name IN ('FSSA', 'NFSA', 'CPA')
    ON CONFLICT DO NOTHING;

INSERT INTO incident_category_acts (incident_category_id, act_id)
SELECT ic.id, a.id FROM incident_categories ic, acts a WHERE ic.code = 'HEALTHCARE_ISSUE' AND a.short_name = 'CPA'
    ON CONFLICT DO NOTHING;

INSERT INTO incident_category_acts (incident_category_id, act_id)
SELECT ic.id, a.id FROM incident_categories ic, acts a WHERE ic.code = 'HOUSING_ISSUE' AND a.short_name IN ('RERA', 'CPA')
    ON CONFLICT DO NOTHING;

INSERT INTO incident_category_acts (incident_category_id, act_id)
SELECT ic.id, a.id FROM incident_categories ic, acts a WHERE ic.code = 'POLLUTION' AND a.short_name IN ('EPA', 'APCPA')
    ON CONFLICT DO NOTHING;

INSERT INTO incident_category_acts (incident_category_id, act_id)
SELECT ic.id, a.id FROM incident_categories ic, acts a WHERE ic.code = 'CORRUPTION' AND a.short_name IN ('PCA', 'RTI')
    ON CONFLICT DO NOTHING;

INSERT INTO incident_category_acts (incident_category_id, act_id)
SELECT ic.id, a.id FROM incident_categories ic, acts a WHERE ic.code = 'CONSUMER_ISSUE' AND a.short_name = 'CPA'
    ON CONFLICT DO NOTHING;

INSERT INTO incident_category_acts (incident_category_id, act_id)
SELECT ic.id, a.id FROM incident_categories ic, acts a WHERE ic.code = 'CYBERCRIME' AND a.short_name IN ('ITA', 'CPA')
    ON CONFLICT DO NOTHING;

INSERT INTO incident_category_acts (incident_category_id, act_id)
SELECT ic.id, a.id FROM incident_categories ic, acts a WHERE ic.code = 'PENSION_ISSUE' AND a.short_name IN ('EPFA', 'CPA')
    ON CONFLICT DO NOTHING;

INSERT INTO incident_category_acts (incident_category_id, act_id)
SELECT ic.id, a.id FROM incident_categories ic, acts a WHERE ic.code = 'TELECOM_ISSUE' AND a.short_name IN ('ITA', 'CPA')
    ON CONFLICT DO NOTHING;

INSERT INTO incident_category_acts (incident_category_id, act_id)
SELECT ic.id, a.id FROM incident_categories ic, acts a WHERE ic.code = 'WASTE_MANAGEMENT' AND a.short_name IN ('EPA', 'APCPA')
    ON CONFLICT DO NOTHING;

INSERT INTO incident_category_acts (incident_category_id, act_id)
SELECT ic.id, a.id FROM incident_categories ic, acts a WHERE ic.code = 'SCHOOL_EDUCATION' AND a.short_name IN ('RTE', 'CPA')
    ON CONFLICT DO NOTHING;