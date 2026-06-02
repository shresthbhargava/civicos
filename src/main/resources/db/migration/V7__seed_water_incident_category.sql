-- Water supply incident category linked to central ministry
-- Location-aware search will override this with state/district departments
-- based on citizen location at query time

INSERT INTO incident_categories (name, code, description, department_id, keywords, citizen_actions)
VALUES (
           'Water Supply Failure',
           'WATER_SUPPLY_FAILURE',
           'Covers water supply disruptions, contamination, non-functional taps, tanker delays, and infrastructure failures',
           (SELECT id FROM departments WHERE code = 'MIN_RURAL_CENTRAL'),
           ARRAY[
               'water', 'supply', 'tap', 'pipeline', 'tanker',
           'contamination', 'leakage', 'shortage', 'borewell',
           'drinking', 'sewage', 'sanitation', 'drain'
               ],
           ARRAY[
               'Register complaint on National Grievance Portal at pgportal.gov.in',
           'File complaint with your state water board directly',
           'Submit RTI to local water authority for pipeline maintenance records',
           'Contact district collector office if state authority is unresponsive'
               ]
       );