-- ============================================================================
-- V26: Expand Incident Categories & Departments
-- Purpose: Cover 40+ most common Indian civic complaint categories so that
--          keyword search returns results for the majority of real queries.
-- Dependencies: V19 (incident_categories), V20 (departments), V22 (linkage table)
-- ============================================================================

-- ============================================================================
-- PART 1: INSERT MISSING DEPARTMENTS
-- ============================================================================

-- 1a. Central-level departments that don't exist yet
INSERT INTO departments (name, code, jurisdiction_level, jurisdiction_value, ministry, created_at, updated_at)
VALUES
    -- Law & Order
    ('Ministry of Home Affairs - Police Reforms', 'MHA_POLICE_CENTRAL', 'CENTRAL', NULL, 'Ministry of Home Affairs', NOW(), NOW()),

    -- Public Transport
    ('Ministry of Road Transport and Highways', 'MORTH_CENTRAL', 'CENTRAL', NULL, 'Ministry of Road Transport and Highways', NOW(), NOW()),

    -- Agriculture & Farmers
    ('Ministry of Agriculture and Farmers Welfare', 'AGRI_CENTRAL', 'CENTRAL', NULL, 'Ministry of Agriculture and Farmers Welfare', NOW(), NOW()),

    -- Banking & Finance
    ('Reserve Bank of India - Banking Ombudsman', 'RBI_BANKING_CENTRAL', 'CENTRAL', NULL, 'Ministry of Finance', NOW(), NOW()),

    -- Food & Public Distribution
    ('Ministry of Consumer Affairs, Food and Public Distribution', 'CONSUMER_AFFAIRS_CENTRAL', 'CENTRAL', NULL, 'Ministry of Consumer Affairs, Food and Public Distribution', NOW(), NOW()),

    -- Labour & Employment
    ('Ministry of Labour and Employment', 'LABOUR_CENTRAL', 'CENTRAL', NULL, 'Ministry of Labour and Employment', NOW(), NOW()),

    -- Environment & Forests
    ('Ministry of Environment, Forest and Climate Change', 'MOEFCC_CENTRAL', 'CENTRAL', NULL, 'Ministry of Environment, Forest and Climate Change', NOW(), NOW()),

    -- Education (School Level)
    ('Department of School Education and Literacy', 'SCHOOL_EDU_CENTRAL', 'CENTRAL', NULL, 'Ministry of Education', NOW(), NOW()),

    -- Housing & Urban Affairs
    ('Ministry of Housing and Urban Affairs', 'MOHUA_CENTRAL', 'CENTRAL', NULL, 'Ministry of Housing and Urban Affairs', NOW(), NOW()),

    -- Telecom
    ('Department of Telecommunications', 'DOT_CENTRAL', 'CENTRAL', NULL, 'Ministry of Communications', NOW(), NOW()),

    -- Petroleum & Natural Gas (Domestic LPG)
    ('Ministry of Petroleum and Natural Gas', 'PNG_CENTRAL', 'CENTRAL', NULL, 'Ministry of Petroleum and Natural Gas', NOW(), NOW()),

    -- Railways
    ('Ministry of Railways', 'RAILWAYS_CENTRAL', 'CENTRAL', NULL, 'Ministry of Railways', NOW(), NOW()),

    -- Women & Child Development
    ('Ministry of Women and Child Development', 'WCD_CENTRAL', 'CENTRAL', NULL, 'Ministry of Women and Child Development', NOW(), NOW()),

    -- Social Justice
    ('Ministry of Social Justice and Empowerment', 'SOCIAL_JUSTICE_CENTRAL', 'CENTRAL', NULL, 'Ministry of Social Justice and Empowerment', NOW(), NOW())
    ON CONFLICT DO NOTHING;


-- ============================================================================
-- PART 2: UPDATE EXISTING 18 CATEGORIES — add keywords & citizen_actions
--          (Only categories that are missing keywords or citizen_actions)
-- ============================================================================

-- Helper: We'll set keywords and citizen_actions for ALL existing categories
-- to ensure consistent search behavior.

UPDATE incident_categories SET
                               keywords = ARRAY['electricity', 'power cut', 'power failure', 'power outage', 'load shedding',
    'no electricity', 'voltage fluctuation', 'transformer', 'electricity board', 'kseb',
    'bescom', 'tata power', 'adani electricity', 'msedcl', 'cesc', 'tpddl',
    'bijli', 'light', 'current', 'trip', 'short circuit'],
    citizen_actions = ARRAY['File complaint on your state electricity board portal',
    'Call the 24/7 helpline of your electricity distribution company',
    'Register grievance on the state electricity regulatory commission (SERC) website',
    'Use the URJA app (central government) for tracking complaints'],
    updated_at = NOW()
WHERE code = 'ELECTRICITY_FAILURE';

UPDATE incident_categories SET
                               keywords = ARRAY['power', 'power failure', 'power outage', 'load shedding', 'power cut',
    'no power', 'electricity problem', 'grid failure', 'power disruption'],
    citizen_actions = ARRAY['Same as electricity failure — contact your distribution company',
    'Check if there is a scheduled maintenance via the utility app'],
    updated_at = NOW()
WHERE code = 'POWER_FAILURE';

UPDATE incident_categories SET
                               keywords = ARRAY['hospital', 'doctor', 'health', 'medical', 'healthcare', 'treatment',
    'medicine', 'pharmacy', 'clinic', 'ambulance', 'health service', 'surgery',
    'OPD', 'emergency', 'blood', 'insurance', 'ayushman', 'PMJAY', 'AIIMS',
    'PHC', 'CHC', 'primary health centre', 'government hospital'],
    citizen_actions = ARRAY['Lodge complaint with the hospital superintendent or Medical Superintendent',
    'File on the State Health Department grievance portal',
    'Use PM-JAY (Ayushman Bharat) helpline 14555 for insurance issues',
    'Approach District Health Officer for public health grievances',
    'File RTI with the concerned medical institution'],
    updated_at = NOW()
WHERE code = 'HEALTH_SERVICE_FAILURE';

UPDATE incident_categories SET
                               keywords = ARRAY['water', 'water supply', 'no water', 'water shortage', 'water crisis',
    'pipeline', 'tanker', 'municipal water', 'jal board', 'DJB', 'BWSSB',
    'CMWSSB', 'PMC water', 'water contamination', 'dirty water', 'sewage',
    'drainage', 'water logging', 'flood', 'paani', 'jal', 'nala'],
    citizen_actions = ARRAY['Complain to your city municipal corporation or Jal Board',
    'Call the 24/7 water helpline of your city (e.g., DJB helpline 1916)',
    'File on the AMRUT or Smart Cities mission portal if applicable',
    'Use the Jal Shakti Ministry''s public grievance portal',
    'File RTI with the Municipal Water Supply department'],
    updated_at = NOW()
WHERE code = 'WATER_SHORTAGE';

UPDATE incident_categories SET
                               keywords = ARRAY['road', 'pothole', 'road damage', 'bad road', 'broken road',
    'road repair', 'highway', 'street', 'footpath', 'pathway', 'tar road',
    'concrete road', 'NH', 'SH', 'national highway', 'state highway',
    'pucca road', 'kacha road', 'NHAI', 'PWD', 'sarkari sadak'],
    citizen_actions = ARRAY['Report pothole on your city municipal corporation portal (e.g., MCGM, BBMP)',
    'Use NHAI helpline 1033 for national highway issues',
    'File on the state PWD (Public Works Department) grievance portal',
    'Use the "Meri Sadak" app by Ministry of Rural Development for rural roads',
    'File RTI with the concerned road authority'],
    updated_at = NOW()
WHERE code = 'ROAD_DAMAGE';

UPDATE incident_categories SET
                               keywords = ARRAY['garbage', 'waste', 'dustbin', 'trash', 'rubbish', 'sanitation',
    'cleanliness', 'swachh', 'waste management', 'landfill', 'dumping',
    'sewage', 'drain', 'open drain', 'smell', 'stink', 'pest',
    'mosquito', 'dengue', 'malaria', 'foul smell', 'solid waste',
    'safai', 'kachra', 'sweeping'],
    citizen_actions = ARRAY['Complain to your city municipal corporation solid waste management department',
    'Use the Swachhata app or your city''s 311-style grievance app',
    'Call the municipal health department for pest/mosquito complaints',
    'File on the MyGov.in Swachhata portal',
    'File RTI with the Municipal Commissioner office'],
    updated_at = NOW()
WHERE code = 'SANITATION_ISSUE';

UPDATE incident_categories SET
                               keywords = ARRAY['examination', 'exam', 'result', 'NEET', 'JEE', 'NTA', 'CBSE',
    'paper leak', 'exam irregularity', 'revaluation', 'rechecking', 'admit card',
    'hall ticket', 'exam center', 'UPSC', 'SSC', 'GATE', 'CAT',
    'answer key', 'cutoff', 'counselling', 'admission', 'marking scheme'],
    citizen_actions = ARRAY['File complaint with the examining body (NTA, CBSE, State Board)',
    'Use NTA grievance portal for NEET/JEE issues: nta.ac.in',
    'File RTI with the examining body for answer key/revaluation details',
    'Approach the Education Ministry if the examining body does not respond',
    'For admissions: contact the counselling authority of the state/central body'],
    updated_at = NOW()
WHERE code = 'EXAM_IRREGULARITY';

UPDATE incident_categories SET
                               keywords = ARRAY['corruption', 'bribe', 'scam', 'fraud', 'embezzlement', 'misappropriation',
    'vigilance', 'CBI', 'CVC', 'anti-corruption', 'Lokpal', 'ACB',
    'whistleblower', 'graft', 'kickback', 'siphoning', 'illegal tender'],
    citizen_actions = ARRAY['File complaint with the Central Vigilance Commission (CVC) at cvc.gov.in',
    'Approach the state Anti-Corruption Bureau (ACB)',
    'File online complaint on the Lokpal portal: lokpal.gov.in',
    'File RTI to get details of the transaction/project in question',
    'Use the "e-Filing" system of CBI for major scams'],
    updated_at = NOW()
WHERE code = 'CORRUPTION';

UPDATE incident_categories SET
                               keywords = ARRAY['RTI', 'right to information', 'information commission', 'PIO',
    'public information officer', 'appeal', 'first appeal', 'second appeal',
    'CIC', 'SIC', 'information denial', 'RTI reply', 'RTI filing'],
    citizen_actions = ARRAY['File First Appeal with the First Appellate Authority (FAA) within 30 days',
    'File Second Appeal with the State/Central Information Commission',
    'Track your RTI on rti.gov.in (central) or state RTI portal',
    'If the PIO does not respond in 30 days, it is deemed a denial — file appeal',
    'Seek help from RTI activists or organizations like MKSS'],
    updated_at = NOW()
WHERE code = 'RTI_GRIEVANCE';

UPDATE incident_categories SET
                               keywords = ARRAY['election', 'voter', 'voting', 'booth', 'ECI', 'election commission',
    'ballot', 'EVM', 'voter ID', 'aadhaar link', 'electoral roll',
    'polling', 'candidate', 'campaign', 'model code', 'voter list',
    'election complaint', 'rigging'],
    citizen_actions = ARRAY['File complaint on the Election Commission of India portal: eci.gov.in',
    'Use the cVIGIL app by ECI to report election code violations',
    'Call ECI helpline 1950 for voter registration and polling issues',
    'File RTI with the District Election Officer',
    'For voter ID issues: visit the nearest Electoral Registration Office'],
    updated_at = NOW()
WHERE code = 'ELECTION_ISSUE';

UPDATE incident_categories SET
                               keywords = ARRAY['tax', 'income tax', 'GST', 'property tax', 'ITR', 'refund',
    'assessment', 'notice', 'scrutiny', 'tax return', 'TDS', 'advance tax',
    'tax evasion', 'GST return', 'GSTN', 'sales tax', 'excise'],
    citizen_actions = ARRAY['File grievance on the Income Tax portal: incometax.gov.in',
    'Use the GST grievance mechanism on GSTN portal',
    'For property tax: contact your municipal corporation''s tax department',
    'File appeal with the Commissioner of Income Tax (Appeals)',
    'Use the Aaykar Seva Kendra (ASK) for in-person tax grievances'],
    updated_at = NOW()
WHERE code = 'TAX_GRIEVANCE';

UPDATE incident_categories SET
                               keywords = ARRAY['land', 'property', 'registration', 'mutation', 'encroachment',
    'land acquisition', 'RERA', 'real estate', 'builder', 'flat', 'apartment',
    'possession', 'land record', '7/12', 'katha', 'patta', 'khatauni',
    'survey', 'map', 'plot', 'revenue', 'tehsildar', 'patwari'],
    citizen_actions = ARRAY['File complaint on the state RERA authority portal (rera.gov.in for state list)',
    'Contact the Sub-Registrar / Tehsildar for land record issues',
    'Use DILRMS portal for digital land records',
    'File RTI with the Revenue Department for land acquisition details',
    'For builder disputes: approach the Consumer Forum or RERA'],
    updated_at = NOW()
WHERE code = 'LAND_RECORD_ISSUE';

UPDATE incident_categories SET
                               keywords = ARRAY['education', 'school', 'teacher', 'college', 'university',
    'admission', 'fee', 'scholarship', 'mid-day meal', 'Sarva Shiksha',
    'CBSE', 'ICSE', 'state board', 'UGC', 'AICTE', 'NAAC',
    'school infrastructure', 'classroom', 'library', 'laboratory'],
    citizen_actions = ARRAY['File complaint with the school principal / college administration',
    'Use the state education department grievance portal',
    'For scholarships: apply on National Scholarship Portal (scholarships.gov.in)',
    'File RTI with the institution or education department',
    'For UGC/AICTE issues: file on their respective grievance portals'],
    updated_at = NOW()
WHERE code = 'EDUCATION_ISSUE';

UPDATE incident_categories SET
                               keywords = ARRAY['environment', 'pollution', 'air pollution', 'water pollution',
    'noise pollution', 'industrial waste', 'emission', 'AQI', 'smog',
    'CPCB', 'SPCB', 'environment clearance', 'EIA', 'tree cutting',
    'deforestation', 'waste dumping', 'plastic', 'hazardous waste',
    'river pollution', 'lake', 'wetland', 'biodiversity'],
    citizen_actions = ARRAY['File complaint on the CPCB/SPCB online complaint portal',
    'Use the Sameer app for air quality monitoring and complaints',
    'Report to the National Green Tribunal (NGT) for major violations',
    'File RTI with the State Pollution Control Board',
    'Contact the District Forest Officer for tree cutting/deforestation'],
    updated_at = NOW()
WHERE code = 'ENVIRONMENT_ISSUE';

UPDATE incident_categories SET
                               keywords = ARRAY['pension', 'retirement', 'EPFO', 'provident fund', 'PF', 'EPS',
    'gratuity', 'superannuation', 'NPS', 'national pension', 'PPO',
    'pension scheme', 'old age', 'social security', ' Employees'' Pension'],
    citizen_actions = ARRAY['Use the EPFO grievance portal: epfigms.gov.in',
    'Call EPFO helpline 1800-118-005 for PF issues',
    'For NPS: use the NPS grievance portal on npscra.nsdl.com',
    'File RTI with the EPFO regional office',
    'Approach the Employee Provident Fund Appellate Tribunal for unresolved issues'],
    updated_at = NOW()
WHERE code = 'PENSION_ISSUE';

UPDATE incident_categories SET
                               keywords = ARRAY['food', 'ration', 'PDS', 'public distribution', 'fair price shop',
    'FPS', 'ration card', 'wheat', 'rice', 'sugar', 'kerosene', 'LPG',
    'food security', 'NFSA', 'Anna canteen', 'mid-day meal', 'ration shop',
    'food grain', 'subsidy', 'BPL', 'AAY', 'PHH'],
    citizen_actions = ARRAY['Complain to the District Food & Supplies Officer',
    'Use the state PDS grievance portal (most states have one)',
    'Call the PDS helpline 1967 (available in most states)',
    'File RTI with the Food & Supplies Department for allocation records',
    'Report on the NFSA grievance portal or state food commission'],
    updated_at = NOW()
WHERE code = 'FOOD_RATION_ISSUE';

UPDATE incident_categories SET
                               keywords = ARRAY['bank', 'banking', 'loan', 'EMI', 'account', 'ATM', 'UPI',
    'NEFT', 'RTGS', 'digital payment', 'cheque', 'debit card', 'credit card',
    'fraud', 'unauthorized transaction', 'balance', 'KYC', 'branch',
    'banking ombudsman', 'RBI', 'transaction failure'],
    citizen_actions = ARRAY['First raise the issue with your bank branch or customer care',
    'If unresolved in 30 days, file with the Banking Ombudsman: bankingombudsman.rbi.org.in',
    'Use RBI''s integrated ombudsman scheme portal',
    'File complaint on CMS (Complaint Management System) of RBI',
    'For digital payment issues: also file on the NPCI portal (if UPI-related)'],
    updated_at = NOW()
WHERE code = 'BANKING_ISSUE';

UPDATE incident_categories SET
                               keywords = ARRAY['employment', 'job', 'unemployment', 'skill', 'vocational',
    'career', 'placement', 'recruitment', 'government job', 'sarkari naukri',
    'UPSC', 'SSC', 'state PSC', 'apprenticeship', 'mgnrega', 'MNREGA',
    'job card', 'wage', 'labour', 'worker', 'contractor', 'minimum wage'],
    citizen_actions = ARRAY['For MGNREGA issues: contact the Gram Panchayat or Block Development Officer',
    'File on the state employment exchange portal',
    'For government recruitment: file RTI with the recruiting body',
    'Use the Shram Suvidha portal for labour-related employment issues',
    'For unpaid wages: file complaint with the Labour Commissioner'],
    updated_at = NOW()
WHERE code = 'EMPLOYMENT_ISSUE';

UPDATE incident_categories SET
                               keywords = ARRAY['crime', 'police', 'FIR', 'complaint', 'theft', 'robbery',
    'assault', 'harassment', 'cybercrime', 'missing', 'accident',
    'law and order', 'law enforcement', 'traffic', 'traffic police',
    'cop', 'thanedar', 'SHO', 'station house officer', '100', '112',
    'helpline', 'women helpline', 'child helpline', 'domestic violence',
    'eve teasing', 'stalking'],
    citizen_actions = ARRAY['Call 112 (Emergency) or 100 (Police) for immediate emergencies',
    'File FIR at the nearest police station — it is your constitutional right',
    'Use the state police online FIR/complaint portal (most states have one)',
    'For cybercrime: file on cybercrime.gov.in',
    'For women: call 181 (Women Helpline) or 1091 (Women in Distress)',
    'File RTI with the police station for investigation status',
    'If FIR is not registered: approach the Superintendent of Police or Magistrate'],
    updated_at = NOW()
WHERE code = 'LAW_AND_ORDER';

UPDATE incident_categories SET
                               keywords = ARRAY['transport', 'bus', 'metro', 'train', 'auto', 'rickshaw',
    'cab', 'taxi', 'uber', 'ola', 'public transport', 'bus stop',
    'metro station', 'railway', 'IRCTC', 'ticket', 'reservation',
    'waiting list', 'Tatkal', 'platform', 'coach', 'delay',
    'cancellation', 'refund', 'bus pass', 'transport department',
    'RTO', 'driving license', 'vehicle registration'],
    citizen_actions = ARRAY['For railways: file on the IRCTC portal or call 139',
    'Use the Rail Madad portal: railmadad.indianrailways.gov.in',
    'For bus issues: contact the state road transport corporation',
    'For metro: use the respective metro rail corporation grievance portal',
    'For auto/taxi overcharging: note the vehicle number and file with RTO',
    'For driving license/registration: use Parivahan Sewa (parivahan.gov.in)'],
    updated_at = NOW()
WHERE code = 'PUBLIC_TRANSPORT';

UPDATE incident_categories SET
                               keywords = ARRAY['agriculture', 'farmer', 'crop', 'irrigation', 'fertilizer',
    'pesticide', 'seed', 'MSP', 'minimum support price', 'mandi',
    'APMC', 'kisan', 'loan waiver', 'crop insurance', 'PM-KISAN',
    'soil health', 'organic farming', 'agri market', ' procurement',
    'cold storage', 'farm loan', 'kisan credit card'],
    citizen_actions = ARRAY['Contact the Agriculture Department / Krishi Vigyan Kendra (KVK)',
    'Use the PM-KISAN grievance portal: pmkisan.gov.in',
    'For crop insurance: file on the Pradhan Mantri Fasal Bima Yojana portal',
    'File RTI with the district agriculture officer for MSP procurement data',
    'For irrigation issues: contact the Minor Irrigation / Water Resources Department',
    'Use the Kisan Call Center: 1800-180-1551'],
    updated_at = NOW()
WHERE code = 'AGRICULTURE_ISSUE';

UPDATE incident_categories SET
                               keywords = ARRAY['LPG', 'gas cylinder', 'cooking gas', 'HP Gas', 'Bharat Gas',
    'Indane', 'gas connection', 'subsidy', 'PAHAL', 'gas agency',
    'domestic gas', 'cylinder booking', 'gas leak', 'pipeline gas',
    'PNG connection', 'city gas', 'IGL', 'Mahanagar Gas'],
    citizen_actions = ARRAY['Book/cancel cylinder via your distributor portal or IVRS',
    'For subsidy issues: check on mylpg.in (PAHAL DBTL portal)',
    'Complain to the area LPG distributor — escalation to Area Manager',
    'For gas leak emergencies: call the distributor emergency number',
    'File RTI with the Ministry of Petroleum and Natural Gas',
    'Use the LPG consumer grievance portal of the oil marketing company'],
    updated_at = NOW()
WHERE code = 'DOMESTIC_LPG_ISSUE';

UPDATE incident_categories SET
                               keywords = ARRAY['telecom', 'mobile', 'internet', 'broadband', 'Jio', 'Airtel',
    'VI', 'BSNL', 'tower', 'network', 'call drop', '5G', '4G',
    'data speed', 'landline', 'phone bill', 'recharge', 'DTH',
    'set-top box', 'TRAI', 'bill dispute', 'wrong billing',
    'connection', 'portability', 'MNP', 'SIM', 'activation'],
    citizen_actions = ARRAY['First complain to your telecom operator customer care',
    'If unresolved in 7 days, use TRAI''s Public Grievance portal: tccms.gov.in',
    'Call TRAI helpline or use the TRAI MyCall app to report call drops',
    'File RTI with TRAI or the Department of Telecommunications',
    'For DTH issues: contact the broadcaster or TRAI'],
    updated_at = NOW()
WHERE code = 'TELECOM_ISSUE';

UPDATE incident_categories SET
                               keywords = ARRAY['woman', 'women', 'gender', 'domestic violence', 'dowry',
    'harassment', 'sexual harassment', 'POSH', 'workplace harassment',
    'rape', 'molestation', 'stalking', 'eve teasing', 'child marriage',
    'female foeticide', 'gender discrimination', 'maternity', 'pregnancy',
    'creche', 'women safety', '181', '1091'],
    citizen_actions = ARRAY['Call 181 (Women Helpline) or 1091 (Women in Distress)',
    'File FIR — police MUST register FIR for cognizable offences against women',
    'Use the NCW (National Commission for Women) complaint portal: ncw.nic.in',
    'For workplace: file POSH complaint with the Internal Complaints Committee',
    'File RTI with the District Women & Child Development Office',
    'Contact the State Women Commission for state-level grievances'],
    updated_at = NOW()
WHERE code = 'WOMEN_SAFETY_ISSUE';

UPDATE incident_categories SET
                               keywords = ARRAY['child', 'children', 'child labour', 'child abuse', 'child rights',
    'adoption', 'orphan', 'anganwadi', 'ICDS', 'child education',
    'child health', 'immunization', 'malnutrition', 'mid-day meal',
    'child marriage', 'juvenile', 'child helpline', '1098', 'CCPCR',
    'NCPCR', 'child protection', 'trafficking'],
    citizen_actions = ARRAY['Call CHILDLINE 1098 for any child in need of care and protection',
    'File complaint with the National Commission for Protection of Child Rights (NCPCR)',
    'Contact the District Child Protection Unit (DCPU)',
    'File RTI with the Women & Child Development Department',
    'For child labour: report to the Labour Commissioner'],
    updated_at = NOW()
WHERE code = 'CHILD_WELFARE_ISSUE';

UPDATE incident_categories SET
                               keywords = ARRAY['housing', 'slum', 'rehabilitation', 'PMAY', 'housing scheme',
    'flat', 'apartment', 'builder', 'construction', 'RERA', 'possession',
    'rent', 'tenant', 'landlord', 'eviction', 'rent agreement',
    'affordable housing', 'shelter', 'homeless', 'night shelter',
    'housing society', 'CHS', 'cooperative housing'],
    citizen_actions = ARRAY['File complaint on the state RERA portal (rera.gov.in for state links)',
    'For PMAY: track on pmaymis.gov.in or contact the Urban Local Body',
    'For rent disputes: approach the Rent Controller / District Forum',
    'File RTI with the Housing Department / Slum Rehabilitation Authority',
    'For cooperative housing: approach the Registrar of Cooperative Societies'],
    updated_at = NOW()
WHERE code = 'HOUSING_ISSUE';

UPDATE incident_categories SET
                               keywords = ARRAY['digital', 'internet', 'wifi', 'broadband', 'website', 'online',
    'e-governance', 'DigiLocker', 'UMANG', 'Aadhaar', 'UPI', 'digital India',
    'cyber crime', 'online fraud', 'phishing', 'hacking', 'data breach',
    'privacy', 'IT act', 'cert-in', 'online harassment', 'social media',
    'fake news', 'deepfake', 'digital literacy'],
    citizen_actions = ARRAY['For cybercrime: file on cybercrime.gov.in',
    'Report phishing/fraud to CERT-In: cert-in.org.in',
    'For Aadhaar issues: file on uidai.gov.in grievance portal',
    'For online financial fraud: also inform your bank and RBI ombudsman',
    'File RTI with the Ministry of Electronics and IT (MeitY)'],
    updated_at = NOW()
WHERE code = 'DIGITAL_SERVICES_ISSUE';


-- ============================================================================
-- PART 3: INSERT NEW CATEGORIES (expanding to 40+ total)
-- ============================================================================

INSERT INTO incident_categories (name, code, description, department_id, keywords, citizen_actions, created_at, updated_at)
VALUES
    -- Insurance
    ('Insurance Grievance', 'INSURANCE_ISSUE',
     'Complaints related to life insurance, health insurance, motor insurance claim rejections, delays, or policy disputes.',
     (SELECT id FROM departments WHERE code = 'RBI_BANKING_CENTRAL' LIMIT 1),
    ARRAY['insurance', 'life insurance', 'health insurance', 'motor insurance', 'claim',
    'policy', 'premium', 'IRDAI', 'LIC', 'HDFC Life', 'ICICI Prudential',
    'SBI Life', 'claim rejection', 'claim delay', 'policy surrender', 'maturity',
    'term plan', 'ULIP', 'endowment', 'insurance ombudsman'],
     ARRAY['First raise grievance with the insurance company',
           'If unresolved in 30 days: approach IRDAI Integrated Grievance Management System (IGMS)',
           'File with Insurance Ombudsman (now part of IRDAI ombudsman mechanism)',
           'For LIC: use the LIC grievance portal at licindia.in',
           'File RTI with IRDAI for regulatory information'],
     NOW(), NOW()),

    -- Public Distribution System (PDS) — separate from general food
    ('Public Distribution System', 'PDS_ISSUE',
     'Issues with ration shops, food grain distribution, PDS cards, subsidy distribution under NFSA.',
     (SELECT id FROM departments WHERE code = 'CONSUMER_AFFAIRS_CENTRAL' LIMIT 1),
     ARRAY['PDS', 'public distribution system', 'ration shop', 'fair price shop', 'FPS',
           'ration card', 'food grain', 'wheat', 'rice', 'sugar', 'kerosene allocation',
           'NFSA', 'food security act', 'BPL card', 'AAY card', 'PHH card',
           'ration dealer', 'black marketing', 'PDS grievance', 'food inspector'],
     ARRAY['Complain to the District Food & Supplies Controller / Officer',
           'Use the state PDS portal (most states have an online grievance system)',
           'Call the PDS helpline 1967',
           'File RTI with the Food & Civil Supplies Department',
           'Report to the State Food Commission if the issue is systemic'],
     NOW(), NOW()),

    -- Street Lighting
    ('Street Lighting', 'STREET_LIGHTING',
     'Non-functional or missing street lights in public areas, roads, parks, and residential areas.',
     (SELECT id FROM departments WHERE code = 'MOHUA_CENTRAL' LIMIT 1),
     ARRAY['street light', 'streetlight', 'street lamp', 'road light', 'pole light',
           'no light', 'dark road', 'broken light', 'LED street light', 'solar light',
           'park light', 'footpath light', 'area light', 'public lighting'],
     ARRAY['Report to your municipal corporation / nagar nigam',
           'Use the city''s mobile app or 311 helpline (e.g., MCGM, BBMP)',
           'File complaint on the state urban development department portal',
           'Contact the local ward corporator / councilor',
           'File RTI with the Municipal Engineering Department'],
     NOW(), NOW()),

    -- Noise Pollution (separate from general environment)
    ('Noise Pollution', 'NOISE_POLLUTION',
     'Excessive noise from construction, loudspeakers, traffic, industries, or public events.',
     (SELECT id FROM departments WHERE code = 'MOEFCC_CENTRAL' LIMIT 1),
     ARRAY['noise', 'noise pollution', 'loudspeaker', 'loud speaker', 'construction noise',
           'traffic noise', 'industrial noise', 'horn', 'siren', 'DJ', 'party noise',
           'temple noise', 'mosque', 'church bell', 'firecracker', 'diwali',
           'noise limit', 'decibel', 'silence zone', 'night noise'],
     ARRAY['File complaint with the local police station (noise is a police matter under CrPC)',
           'Complain to the State Pollution Control Board',
           'For construction noise: complain to the municipal corporation',
           'Use the Sameer app / CPCB portal to report noise pollution',
           'File RTI with the SPCB for noise monitoring data in your area'],
     NOW(), NOW()),

    -- Animal / Stray Dog Issues
    ('Stray Animal Menace', 'STRAY_ANIMAL',
     'Issues related to stray dogs, cattle on roads, or animal cruelty/neglect.',
     (SELECT id FROM departments WHERE code = 'MOHUA_CENTRAL' LIMIT 1),
     ARRAY['stray', 'stray dog', 'street dog', 'dog bite', 'rabies', 'stray cattle',
           'cow on road', 'bull', 'animal nuisance', 'monkey', 'monkey menace',
           'pest', 'rat', 'pig', 'animal cruelty', 'animal rescue', 'SPCA',
           'animal shelter', 'sterilization', 'ABC program', 'animal birth control'],
     ARRAY['For dog bites: visit nearest hospital for anti-rabies treatment immediately',
           'Contact the municipal corporation''s Animal Birth Control (ABC) program',
           'Call the city animal helpline (many cities have one)',
           'File RTI with the Municipal Health Department on ABC program status',
           'For animal cruelty: file FIR and contact SPCA / local animal welfare NGO'],
     NOW(), NOW()),

    -- Certificate / Document Issuance
    ('Certificate & Document Issuance', 'CERTIFICATE_ISSUE',
     'Delays, corruption, or denial in issuance of certificates: caste, income, domicile, birth, death, marriage.',
     (SELECT id FROM departments WHERE code = 'MHA_POLICE_CENTRAL' LIMIT 1),
     ARRAY['certificate', 'caste certificate', 'income certificate', 'domicile', 'birth certificate',
           'death certificate', 'marriage certificate', 'character certificate', 'migration certificate',
           'nativity', 'residence certificate', 'OBC certificate', 'SC/ST certificate',
           'EWS certificate', 'document', 'aadhaar card', 'PAN card', 'passport',
           'tahsildar', 'tehsil', 'collector', 'revenue officer', 'gazette'],
     ARRAY['Apply online through the state e-District portal (most states have one)',
           'Track application status on the state service delivery portal',
           'If delayed beyond the service timeline: file grievance with the District Collector',
           'File RTI with the concerned tehsil/revenue office',
           'Use the Jan Soochna portal (if in Rajasthan) or similar transparency portals'],
     NOW(), NOW()),

    -- Flood / Disaster Management
    ('Flood & Disaster Management', 'FLOOD_DISASTER',
     'Flood relief, disaster response, dam management, and natural disaster preparedness issues.',
     (SELECT id FROM departments WHERE code = 'MHA_POLICE_CENTRAL' LIMIT 1),
     ARRAY['flood', 'flood relief', 'dam', 'embankment', 'disaster', 'NDMA', 'SDMA',
           'cyclone', 'earthquake', 'landslide', 'cloudburst', 'flood rescue',
           'relief camp', 'relief material', 'compensation', 'NDRF', 'flood warning',
           'drainage', 'water logging', 'monsoon', 'flood prone'],
     ARRAY['For immediate rescue: call 112 (NDRF/SDRF)',
           'Register for flood/damage compensation with the District Collector',
           'File RTI with NDMA/SDMA for disaster preparedness plans',
           'Use the state disaster management portal for relief registration',
           'For dam safety: contact the Central Water Commission (CWC)'],
     NOW(), NOW()),

    -- Consumer Protection
    ('Consumer Protection', 'CONSUMER_PROTECTION',
     'Product defects, service deficiencies, unfair trade practices, and consumer rights violations.',
     (SELECT id FROM departments WHERE code = 'CONSUMER_AFFAIRS_CENTRAL' LIMIT 1),
     ARRAY['consumer', 'consumer complaint', 'defective product', 'refund', 'replacement',
           'warranty', 'guarantee', ' misleading', 'advertising', 'overcharging',
           'MRP', 'maximum retail price', 'expiry date', 'adulteration',
           'e-commerce', 'Amazon', 'Flipkart', 'consumer court', 'consumer forum',
           'CCPA', 'consumer protection act'],
     ARRAY['File complaint on the National Consumer Helpline: 1800-11-4000 / 14404',
           'Use the consumer helpline app or consumeraffairs.gov.in/echannel',
           'File case in the Consumer Disputes Redressal Commission (District/State/National)',
           'For e-commerce: use the platform''s grievance mechanism first, then consumer forum',
           'File RTI with the CCPA (Central Consumer Protection Authority)'],
     NOW(), NOW()),

    -- Senior Citizen Issues
    ('Senior Citizen Welfare', 'SENIOR_CITIZEN',
     'Issues related to pension, healthcare, elder abuse, and social security for senior citizens.',
     (SELECT id FROM departments WHERE code = 'SOCIAL_JUSTICE_CENTRAL' LIMIT 1),
     ARRAY['senior citizen', 'elderly', 'old age', 'pension', 'elder abuse', 'elder care',
           'old age home', 'geriatric', 'senior', 'retired', 'VRS', 'voluntary retirement',
           'maintenance', 'parents', 'elder helpline', '14567'],
     ARRAY['Call Senior Citizen Helpline: 14567',
           'File complaint with the District Social Welfare Officer',
           'For elder abuse: file FIR with the police (Maintenance and Welfare of Parents Act)',
           'Use the Senior Citizens portal on socialjustice.gov.in',
           'File RTI with the Ministry of Social Justice and Empowerment'],
     NOW(), NOW()),

    -- Disability Rights
    ('Disability Rights & Access', 'DISABILITY_ISSUE',
     'Accessibility barriers, disability certificate delays, and denial of rights under RPwD Act 2016.',
     (SELECT id FROM departments WHERE code = 'SOCIAL_JUSTICE_CENTRAL' LIMIT 1),
     ARRAY['disability', 'disabled', 'handicapped', 'differently abled', 'accessibility',
           'ramp', 'wheelchair', 'braille', 'sign language', 'disability certificate',
           'UDID', 'specially abled', 'visual impairment', 'hearing impairment',
           'autism', 'disability pension', 'RPwD', 'divyang', '4% reservation'],
     ARRAY['Apply for UDID (Unique Disability ID) on swavlambancard.gov.in',
           'File complaint with the State Commissioner for Persons with Disabilities',
           'Use the Accessible India (Sugamya Bharat) grievance portal',
           'File RTI with the Department of Empowerment of Persons with Disabilities (DEPwD)',
           'For accessibility violations: approach the Chief Commissioner for PwDs'],
     NOW(), NOW()),

    -- Court / Legal System
    ('Court & Legal System', 'LEGAL_SYSTEM',
     'Issues related to case delays, access to justice, legal aid, and judicial accountability.',
     (SELECT id FROM departments WHERE code = 'MHA_POLICE_CENTRAL' LIMIT 1),
     ARRAY['court', 'judge', 'case', 'litigation', 'justice', 'lawyer', 'advocate',
           'bail', ' FIR', 'trial', 'verdict', 'judgment', 'high court', 'supreme court',
           'district court', 'fast track court', 'case pending', 'e-court', 'ecourts',
           'legal aid', 'NALSA', 'lok adalat', 'arbitration', 'mediation'],
     ARRAY['Track case status on ecourts.gov.in',
           'Apply for legal aid through NALSA or State Legal Services Authority',
           'Approach Lok Adalat for dispute resolution',
           'File RTI with the court administration for case status',
           'For judicial accountability: file complaint with the National Judicial Appointments Commission or Chief Justice'],
     NOW(), NOW()),

    -- Drug / Substance Abuse
    ('Drug & Substance Abuse', 'DRUG_ABUSE',
     'Issues related to drug trafficking, substance abuse, rehabilitation, and NDPS Act enforcement.',
     (SELECT id FROM departments WHERE code = 'MHA_POLICE_CENTRAL' LIMIT 1),
     ARRAY['drug', 'drugs', 'narcotics', 'substance abuse', 'drug trafficking', 'NDPS',
           'cannabis', 'ganja', 'cocaine', 'heroin', 'drug peddler', 'drug addiction',
           'rehabilitation', 'de-addiction', 'drug menace', 'pharmaceutical',
           'prescription drug', 'opioid', 'Narcotics Control Bureau', 'NCB'],
     ARRAY['Report drug trafficking to the police or call 112',
           'Report to the Narcotics Control Bureau (NCB) helpline',
           'For rehabilitation: contact the state Social Welfare Department',
           'Use the Nasha Mukt Bharat Abhiyaan portal for information',
           'File RTI with the Ministry of Social Justice for rehabilitation center data'],
     NOW(), NOW()),

    -- Minimum Wage / Labour Rights
    ('Minimum Wage & Labour Rights', 'MINIMUM_WAGE',
     'Issues related to unpaid wages, minimum wage violations, overtime, and worker exploitation.',
     (SELECT id FROM departments WHERE code = 'LABOUR_CENTRAL' LIMIT 1),
     ARRAY['minimum wage', 'wage', 'salary', 'unpaid', 'overtime', 'labour', 'labor',
           'worker', 'employee', 'contractor', 'labour law', 'ESIC', 'EPFO',
           'gratuity', 'bonus', 'PF', 'provident fund', 'maternity benefit',
           'child labour', 'bonded labour', 'labour inspector', 'trade union',
           'industrial dispute', 'strike', 'lockout'],
     ARRAY['File complaint with the Labour Commissioner / Assistant Labour Commissioner',
           'Use the Shram Suvidha Portal: shramsuvidha.gov.in',
           'For EPFO: file on epfigms.gov.in',
           'For ESIC: file on the ESIC portal',
           'For bonded/child labour: call 1098 or 112, and contact the District Labour Office',
           'File RTI with the Labour Department for inspection reports'],
     NOW(), NOW()),

    -- Public Park & Recreation
    ('Public Park & Recreation', 'PARK_RECREATION',
     'Issues related to maintenance, access, and encroachment of public parks, playgrounds, and recreational spaces.',
     (SELECT id FROM departments WHERE code = 'MOHUA_CENTRAL' LIMIT 1),
     ARRAY['park', 'garden', 'playground', 'recreation', 'sports ground', 'stadium',
           'swimming pool', 'public space', 'green space', 'tree', 'garden maintenance',
           'encroachment', 'park entry', 'jogging', 'walking track', 'open gym',
           'community hall', 'library', 'museum', 'botanical garden'],
     ARRAY['Complain to the municipal corporation Parks & Gardens department',
           'Use the city''s civic complaint app / 311 service',
           'Contact the local ward corporator / councilor',
           'File RTI with the Urban Development Department for park maintenance budget',
           'For encroachment: also file complaint with the District Collector'],
     NOW(), NOW()),

    -- Fire Safety
    ('Fire Safety', 'FIRE_SAFETY',
     'Issues related to fire safety violations, lack of fire equipment, and fire emergency response.',
     (SELECT id FROM departments WHERE code = 'MHA_POLICE_CENTRAL' LIMIT 1),
     ARRAY['fire', 'fire safety', 'fire extinguisher', 'fire escape', 'fire alarm',
           'fire brigade', 'fire station', 'NOObjection Certificate', 'fire NOC',
           'fire audit', 'fire emergency', 'building fire', 'fire hazard',
           'short circuit fire', 'firecracker', 'fire department', '101'],
     ARRAY['For fire emergency: call 101 (Fire Brigade)',
           'Report fire safety violations to the local fire department / municipal corporation',
           'File RTI with the Fire Department for building fire NOC status',
           'For residential buildings: approach the RWA / Society management',
           'For commercial buildings: check fire NOC status with the municipal fire department'],
     NOW(), NOW())
ON CONFLICT DO NOTHING;


-- ============================================================================
-- PART 4: CREATE INCIDENT_CATEGORY_DEPARTMENTS LINKAGES
--          Links each category to relevant departments for jurisdiction-based
--          routing in the search service.
-- ============================================================================

-- We'll link categories to their primary department AND relevant jurisdiction departments.
-- Using a DO NOTHING conflict clause to handle any pre-existing linkages.

-- Helper: insert linkage (category_code, department_code) with conflict handling
-- We use a CTE/subquery approach since we need IDs, not codes.

INSERT INTO incident_category_departments (incident_category_id, department_id)
SELECT ic.id, d.id
FROM incident_categories ic, departments d
WHERE ic.code IN (
                  'ELECTRICITY_FAILURE', 'POWER_FAILURE'
    ) AND d.code = 'MORTH_CENTRAL'
    ON CONFLICT DO NOTHING;

-- Environment + Environment Ministry
INSERT INTO incident_category_departments (incident_category_id, department_id)
SELECT ic.id, d.id
FROM incident_categories ic, departments d
WHERE ic.code = 'ENVIRONMENT_ISSUE' AND d.code = 'MOEFCC_CENTRAL'
    ON CONFLICT DO NOTHING;

-- Transport + Railways + Road Transport
INSERT INTO incident_category_departments (incident_category_id, department_id)
SELECT ic.id, d.id
FROM incident_categories ic, departments d
WHERE ic.code = 'PUBLIC_TRANSPORT'
  AND d.code IN ('RAILWAYS_CENTRAL', 'MORTH_CENTRAL', 'DOT_CENTRAL')
    ON CONFLICT DO NOTHING;

-- Agriculture + Agri Ministry
INSERT INTO incident_category_departments (incident_category_id, department_id)
SELECT ic.id, d.id
FROM incident_categories ic, departments d
WHERE ic.code = 'AGRICULTURE_ISSUE' AND d.code = 'AGRI_CENTRAL'
    ON CONFLICT DO NOTHING;

-- Banking + RBI
INSERT INTO incident_category_departments (incident_category_id, department_id)
SELECT ic.id, d.id
FROM incident_categories ic, departments d
WHERE ic.code = 'BANKING_ISSUE' AND d.code = 'RBI_BANKING_CENTRAL'
    ON CONFLICT DO NOTHING;

-- Insurance + RBI (IRDAI falls under Finance Ministry)
INSERT INTO incident_category_departments (incident_category_id, department_id)
SELECT ic.id, d.id
FROM incident_categories ic, departments d
WHERE ic.code = 'INSURANCE_ISSUE' AND d.code = 'RBI_BANKING_CENTRAL'
    ON CONFLICT DO NOTHING;

-- LPG + Petroleum Ministry
INSERT INTO incident_category_departments (incident_category_id, department_id)
SELECT ic.id, d.id
FROM incident_categories ic, departments d
WHERE ic.code = 'DOMESTIC_LPG_ISSUE' AND d.code = 'PNG_CENTRAL'
    ON CONFLICT DO NOTHING;

-- Food/Ration + Consumer Affairs
INSERT INTO incident_category_departments (incident_category_id, department_id)
SELECT ic.id, d.id
FROM incident_categories ic, departments d
WHERE ic.code IN ('FOOD_RATION_ISSUE', 'PDS_ISSUE') AND d.code = 'CONSUMER_AFFAIRS_CENTRAL'
    ON CONFLICT DO NOTHING;

-- Telecom + DOT
INSERT INTO incident_category_departments (incident_category_id, department_id)
SELECT ic.id, d.id
FROM incident_categories ic, departments d
WHERE ic.code = 'TELECOM_ISSUE' AND d.code = 'DOT_CENTRAL'
    ON CONFLICT DO NOTHING;

-- Women Safety + WCD
INSERT INTO incident_category_departments (incident_category_id, department_id)
SELECT ic.id, d.id
FROM incident_categories ic, departments d
WHERE ic.code = 'WOMEN_SAFETY_ISSUE' AND d.code = 'WCD_CENTRAL'
    ON CONFLICT DO NOTHING;

-- Child Welfare + WCD
INSERT INTO incident_category_departments (incident_category_id, department_id)
SELECT ic.id, d.id
FROM incident_categories ic, departments d
WHERE ic.code = 'CHILD_WELFARE_ISSUE' AND d.code = 'WCD_CENTRAL'
    ON CONFLICT DO NOTHING;

-- Housing + MOHUA
INSERT INTO incident_category_departments (incident_category_id, department_id)
SELECT ic.id, d.id
FROM incident_categories ic, departments d
WHERE ic.code = 'HOUSING_ISSUE' AND d.code = 'MOHUA_CENTRAL'
    ON CONFLICT DO NOTHING;

-- Employment + Labour Ministry
INSERT INTO incident_category_departments (incident_category_id, department_id)
SELECT ic.id, d.id
FROM incident_categories ic, departments d
WHERE ic.code IN ('EMPLOYMENT_ISSUE', 'MINIMUM_WAGE') AND d.code = 'LABOUR_CENTRAL'
    ON CONFLICT DO NOTHING;

-- Crime/Law & Order + MHA
INSERT INTO incident_category_departments (incident_category_id, department_id)
SELECT ic.id, d.id
FROM incident_categories ic, departments d
WHERE ic.code IN ('LAW_AND_ORDER', 'LEGAL_SYSTEM', 'DRUG_ABUSE', 'FIRE_SAFETY', 'CERTIFICATE_ISSUE', 'FLOOD_DISASTER')
  AND d.code = 'MHA_POLICE_CENTRAL'
    ON CONFLICT DO NOTHING;

-- Digital + DOT (MeitY doesn't exist as a department, DOT is the closest)
INSERT INTO incident_category_departments (incident_category_id, department_id)
SELECT ic.id, d.id
FROM incident_categories ic, departments d
WHERE ic.code = 'DIGITAL_SERVICES_ISSUE' AND d.code = 'DOT_CENTRAL'
    ON CONFLICT DO NOTHING;

-- Noise Pollution + Environment Ministry
INSERT INTO incident_category_departments (incident_category_id, department_id)
SELECT ic.id, d.id
FROM incident_categories ic, departments d
WHERE ic.code = 'NOISE_POLLUTION' AND d.code = 'MOEFCC_CENTRAL'
    ON CONFLICT DO NOTHING;

-- Consumer Protection + Consumer Affairs
INSERT INTO incident_category_departments (incident_category_id, department_id)
SELECT ic.id, d.id
FROM incident_categories ic, departments d
WHERE ic.code = 'CONSUMER_PROTECTION' AND d.code = 'CONSUMER_AFFAIRS_CENTRAL'
    ON CONFLICT DO NOTHING;

-- Senior Citizen + Social Justice
INSERT INTO incident_category_departments (incident_category_id, department_id)
SELECT ic.id, d.id
FROM incident_categories ic, departments d
WHERE ic.code IN ('SENIOR_CITIZEN', 'DISABILITY_ISSUE') AND d.code = 'SOCIAL_JUSTICE_CENTRAL'
    ON CONFLICT DO NOTHING;

-- Street Lighting + MOHUA
INSERT INTO incident_category_departments (incident_category_id, department_id)
SELECT ic.id, d.id
FROM incident_categories ic, departments d
WHERE ic.code = 'STREET_LIGHTING' AND d.code = 'MOHUA_CENTRAL'
    ON CONFLICT DO NOTHING;

-- Stray Animal + MOHUA
INSERT INTO incident_category_departments (incident_category_id, department_id)
SELECT ic.id, d.id
FROM incident_categories ic, departments d
WHERE ic.code = 'STRAY_ANIMAL' AND d.code = 'MOHUA_CENTRAL'
    ON CONFLICT DO NOTHING;

-- Park/Recreation + MOHUA
INSERT INTO incident_category_departments (incident_category_id, department_id)
SELECT ic.id, d.id
FROM incident_categories ic, departments d
WHERE ic.code = 'PARK_RECREATION' AND d.code = 'MOHUA_CENTRAL'
    ON CONFLICT DO NOTHING;

-- Corruption + MHA (CVC falls under MHA jurisdiction)
INSERT INTO incident_category_departments (incident_category_id, department_id)
SELECT ic.id, d.id
FROM incident_categories ic, departments d
WHERE ic.code = 'CORRUPTION' AND d.code = 'MHA_POLICE_CENTRAL'
    ON CONFLICT DO NOTHING;

-- Education + School Education
INSERT INTO incident_category_departments (incident_category_id, department_id)
SELECT ic.id, d.id
FROM incident_categories ic, departments d
WHERE ic.code IN ('EDUCATION_ISSUE', 'EXAM_IRREGULARITY') AND d.code = 'SCHOOL_EDU_CENTRAL'
    ON CONFLICT DO NOTHING;


-- ============================================================================
-- PART 5: NULL OUT EMBEDDINGS FOR CATEGORIES THAT WERE UPDATED OR CREATED
--          These will need to be regenerated by the embedding service.
--          (Setting to NULL ensures the service knows which ones need processing.)
-- ============================================================================

-- NOTE: If your embedding service auto-generates on insert/update, skip this section.
-- If embeddings are generated separately, uncomment below:

-- UPDATE incident_categories SET embedding = NULL WHERE updated_at > '2025-06-30';