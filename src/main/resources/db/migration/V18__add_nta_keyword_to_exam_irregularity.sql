-- The "nta" search query (derived from headlines like "NTA: A System Built On
-- Scams?") was never matching EXAM_IRREGULARITY because its keywords array
-- only had specific exam names (jee, neet, cuet, etc.), not "nta" itself.
-- This adds it without touching anything else.

UPDATE incident_categories
SET keywords = array_append(keywords, 'nta')
WHERE code = 'EXAM_IRREGULARITY'
  AND NOT ('nta' = ANY(keywords));