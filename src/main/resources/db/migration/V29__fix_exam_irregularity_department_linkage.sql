-- ============================================================================
-- V29: Fix incorrect department linkage for EXAM_IRREGULARITY
-- V28 incorrectly linked EXAM_IRREGULARITY to SCHOOL_EDU_CENTRAL.
-- EXAM_IRREGULARITY covers centrally conducted entrance exams (NTA/NEET/JEE)
-- which fall under NTA_CENTRAL, not the school education department.
-- ============================================================================

DELETE FROM incident_category_departments
WHERE incident_category_id = (SELECT id FROM incident_categories WHERE code = 'EXAM_IRREGULARITY')
  AND department_id = (SELECT id FROM departments WHERE code = 'SCHOOL_EDU_CENTRAL');