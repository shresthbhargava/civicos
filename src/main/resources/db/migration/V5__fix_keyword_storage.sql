-- Fix keyword storage to use individual normalized words
-- Original seed used mixed phrases and words which breaks && operator matching

UPDATE incident_categories
SET keywords = ARRAY[
    'exam', 'paper', 'leak', 'malpractice',
    'irregularity', 'cheating', 'fraud',
    'nptel', 'jee', 'neet', 'cuet', 'entrance'
    ]
WHERE code = 'EXAM_IRREGULARITY';

UPDATE incident_categories
SET keywords = ARRAY[
    'scholarship', 'ugc', 'university', 'grant',
    'fellowship', 'stipend', 'funding', 'research'
    ]
WHERE code = 'UNIVERSITY_FUNDING';