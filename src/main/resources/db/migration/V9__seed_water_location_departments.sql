-- Link water supply incident to state and district departments
INSERT INTO incident_category_departments
(incident_category_id, department_id, responsibility_level)
VALUES
    (
        (SELECT id FROM incident_categories WHERE code = 'WATER_SUPPLY_FAILURE'),
        (SELECT id FROM departments WHERE code = 'WATER_STATE_MH'),
        'PRIMARY'
    ),
    (
        (SELECT id FROM incident_categories WHERE code = 'WATER_SUPPLY_FAILURE'),
        (SELECT id FROM departments WHERE code = 'WATER_STATE_DL'),
        'PRIMARY'
    ),
    (
        (SELECT id FROM incident_categories WHERE code = 'WATER_SUPPLY_FAILURE'),
        (SELECT id FROM departments WHERE code = 'WATER_DISTRICT_MH_PUNE'),
        'PRIMARY'
    ),
    (
        (SELECT id FROM incident_categories WHERE code = 'WATER_SUPPLY_FAILURE'),
        (SELECT id FROM departments WHERE code = 'WATER_DISTRICT_MH_MUMBAI'),
        'PRIMARY'
    );