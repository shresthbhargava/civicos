-- V30: Ensure 'nta' lowercase keyword exists in EXAM_IRREGULARITY
-- V28 overwrote the keywords array set by V18, losing the lowercase 'nta'
-- token that the search tokenizer produces from headlines like "NTA: A System..."
UPDATE incident_categories
SET keywords = array_append(keywords, 'nta'),
    updated_at = NOW()
WHERE code = 'EXAM_IRREGULARITY'
  AND NOT ('nta' = ANY(keywords));