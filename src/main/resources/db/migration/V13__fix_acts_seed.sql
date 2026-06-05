INSERT INTO incident_category_acts (incident_category_id, act_id)
SELECT ic.id, a.id
FROM incident_categories ic, acts a
WHERE ic.code = 'EXAM_IRREGULARITY' AND a.short_name = 'RTI'
  AND NOT EXISTS (
    SELECT 1 FROM incident_category_acts
    WHERE incident_category_id = ic.id AND act_id = a.id
);

INSERT INTO incident_category_acts (incident_category_id, act_id)
SELECT ic.id, a.id
FROM incident_categories ic, acts a
WHERE ic.code = 'WATER_SUPPLY_FAILURE' AND a.short_name = 'NWP'
  AND NOT EXISTS (
    SELECT 1 FROM incident_category_acts
    WHERE incident_category_id = ic.id AND act_id = a.id
);