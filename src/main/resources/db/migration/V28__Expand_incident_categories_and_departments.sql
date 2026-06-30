-- ============================================================================
-- V28: Expand Incident Categories & Departments
-- Cover 40+ common Indian civic complaint categories with keywords,
-- citizen actions, and department linkages.
-- ============================================================================

-- ============================================================================
-- PART 1: INSERT MISSING DEPARTMENTS (14 new ones)
-- ============================================================================

INSERT INTO departments (name, code, jurisdiction_level, jurisdiction_value, ministry, created_at, updated_at)
VALUES
    ('Ministry of Home Affairs - Police Reforms', 'MHA_POLICE_CENTRAL', 'CENTRAL', NULL, 'Ministry of Home Affairs', NOW(), NOW()),
    ('Ministry of Road Transport and Highways', 'MORTH_CENTRAL', 'CENTRAL', NULL, 'Ministry of Road Transport and Highways', NOW(), NOW()),
    ('Ministry of Agriculture and Farmers Welfare', 'AGRI_CENTRAL', 'CENTRAL', NULL, 'Ministry of Agriculture and Farmers Welfare', NOW(), NOW()),
    ('Reserve Bank of India - Banking Ombudsman', 'RBI_BANKING_CENTRAL', 'CENTRAL', NULL, 'Ministry of Finance', NOW(), NOW()),
    ('Ministry of Consumer Affairs, Food and Public Distribution', 'CONSUMER_AFFAIRS_CENTRAL', 'CENTRAL', NULL, 'Ministry of Consumer Affairs, Food and Public Distribution', NOW(), NOW()),
    ('Ministry of Labour and Employment', 'LABOUR_CENTRAL', 'CENTRAL', NULL, 'Ministry of Labour and Employment', NOW(), NOW()),
    ('Ministry of Environment, Forest and Climate Change', 'MOEFCC_CENTRAL', 'CENTRAL', NULL, 'Ministry of Environment, Forest and Climate Change', NOW(), NOW()),
    ('Department of School Education and Literacy', 'SCHOOL_EDU_CENTRAL', 'CENTRAL', NULL, 'Ministry of Education', NOW(), NOW()),
    ('Ministry of Housing and Urban Affairs', 'MOHUA_CENTRAL', 'CENTRAL', NULL, 'Ministry of Housing and Urban Affairs', NOW(), NOW()),
    ('Department of Telecommunications', 'DOT_CENTRAL', 'CENTRAL', NULL, 'Ministry of Communications', NOW(), NOW()),
    ('Ministry of Petroleum and Natural Gas', 'PNG_CENTRAL', 'CENTRAL', NULL, 'Ministry of Petroleum and Natural Gas', NOW(), NOW()),
    ('Ministry of Railways', 'RAILWAYS_CENTRAL', 'CENTRAL', NULL, 'Ministry of Railways', NOW(), NOW()),
    ('Ministry of Women and Child Development', 'WCD_CENTRAL', 'CENTRAL', NULL, 'Ministry of Women and Child Development', NOW(), NOW()),
    ('Ministry of Social Justice and Empowerment', 'SOCIAL_JUSTICE_CENTRAL', 'CENTRAL', NULL, 'Ministry of Social Justice and Empowerment', NOW(), NOW())
ON CONFLICT DO NOTHING;


-- ============================================================================
-- PART 2: UPDATE EXISTING CATEGORIES — keywords & citizen_actions
-- ============================================================================

UPDATE incident_categories SET
    keywords = ARRAY['electricity','power cut','power failure','power outage','load shedding','no electricity','voltage fluctuation','transformer','electricity board','kseb','bescom','tata power','adani electricity','msedcl','cesc','tpddl','bijli','light','current','trip','short circuit'],
    citizen_actions = ARRAY['File complaint on your state electricity board portal','Call the 24/7 helpline of your electricity distribution company','Register grievance on the state electricity regulatory commission website','Use the URJA app for tracking complaints'],
    updated_at = NOW()
WHERE code = 'ELECTRICITY_FAILURE';

UPDATE incident_categories SET
    keywords = ARRAY['power','power failure','power outage','load shedding','power cut','no power','electricity problem','grid failure','power disruption'],
    citizen_actions = ARRAY['Contact your distribution company customer care','Check scheduled maintenance via the utility app','File on state electricity regulatory commission portal'],
    updated_at = NOW()
WHERE code = 'POWER_FAILURE';

UPDATE incident_categories SET
    keywords = ARRAY['hospital','doctor','health','medical','healthcare','treatment','medicine','pharmacy','clinic','ambulance','health service','surgery','OPD','emergency','blood','insurance','ayushman','PMJAY','AIIMS','PHC','CHC','primary health centre','government hospital'],
    citizen_actions = ARRAY['Lodge complaint with the hospital superintendent','File on the State Health Department grievance portal','Use PM-JAY helpline 14555 for insurance issues','Approach District Health Officer for public health grievances','File RTI with the concerned medical institution'],
    updated_at = NOW()
WHERE code = 'HEALTH_SERVICE_FAILURE';

UPDATE incident_categories SET
    keywords = ARRAY['water','water supply','no water','water shortage','water crisis','pipeline','tanker','municipal water','jal board','DJB','BWSSB','CMWSSB','water contamination','dirty water','sewage','drainage','water logging','flood','paani','jal','nala'],
    citizen_actions = ARRAY['Complain to your city municipal corporation or Jal Board','Call the 24/7 water helpline of your city','File on the AMRUT or Smart Cities mission portal','Use the Jal Shakti Ministry grievance portal','File RTI with the Municipal Water Supply department'],
    updated_at = NOW()
WHERE code = 'WATER_SHORTAGE';

UPDATE incident_categories SET
    keywords = ARRAY['road','pothole','road damage','bad road','broken road','road repair','highway','street','footpath','pathway','tar road','concrete road','NH','SH','national highway','state highway','pucca road','kacha road','NHAI','PWD','sarkari sadak'],
    citizen_actions = ARRAY['Report pothole on your city municipal corporation portal','Use NHAI helpline 1033 for national highway issues','File on the state PWD grievance portal','Use the Meri Sadak app by Ministry of Rural Development for rural roads','File RTI with the concerned road authority'],
    updated_at = NOW()
WHERE code = 'ROAD_DAMAGE';

UPDATE incident_categories SET
    keywords = ARRAY['garbage','waste','dustbin','trash','rubbish','sanitation','cleanliness','swachh','waste management','landfill','dumping','sewage','drain','open drain','smell','stink','pest','mosquito','dengue','malaria','foul smell','solid waste','safai','kachra','sweeping'],
    citizen_actions = ARRAY['Complain to your city municipal corporation solid waste management department','Use the Swachhata app or city 311-style grievance app','Call the municipal health department for pest complaints','File on the MyGov.in Swachhata portal','File RTI with the Municipal Commissioner office'],
    updated_at = NOW()
WHERE code = 'SANITATION_ISSUE';

UPDATE incident_categories SET
    keywords = ARRAY['examination','exam','result','NEET','JEE','NTA','CBSE','paper leak','exam irregularity','revaluation','rechecking','admit card','hall ticket','exam center','UPSC','SSC','GATE','CAT','answer key','cutoff','counselling','admission','marking scheme'],
    citizen_actions = ARRAY['File complaint with the examining body (NTA, CBSE, State Board)','Use NTA grievance portal for NEET/JEE issues','File RTI with the examining body for answer key details','Approach the Education Ministry if examining body does not respond','For admissions: contact the counselling authority'],
    updated_at = NOW()
WHERE code = 'EXAM_IRREGULARITY';

UPDATE incident_categories SET
    keywords = ARRAY['corruption','bribe','scam','fraud','embezzlement','misappropriation','vigilance','CBI','CVC','anti-corruption','Lokpal','ACB','whistleblower','graft','kickback','siphoning','illegal tender'],
    citizen_actions = ARRAY['File complaint with Central Vigilance Commission at cvc.gov.in','Approach the state Anti-Corruption Bureau','File online complaint on the Lokpal portal','File RTI to get details of the transaction in question','Use the e-Filing system of CBI for major scams'],
    updated_at = NOW()
WHERE code = 'CORRUPTION';

UPDATE incident_categories SET
    keywords = ARRAY['RTI','right to information','information commission','PIO','public information officer','appeal','first appeal','second appeal','CIC','SIC','information denial','RTI reply','RTI filing'],
    citizen_actions = ARRAY['File First Appeal with the First Appellate Authority within 30 days','File Second Appeal with the State/Central Information Commission','Track your RTI on rti.gov.in or state RTI portal','If PIO does not respond in 30 days it is deemed denial — file appeal','Seek help from RTI activists or organizations'],
    updated_at = NOW()
WHERE code = 'RTI_GRIEVANCE';

UPDATE incident_categories SET
    keywords = ARRAY['election','voter','voting','booth','ECI','election commission','ballot','EVM','voter ID','aadhaar link','electoral roll','polling','candidate','campaign','model code','voter list','election complaint','rigging'],
    citizen_actions = ARRAY['File complaint on ECI portal: eci.gov.in','Use the cVIGIL app by ECI to report violations','Call ECI helpline 1950 for voter registration issues','File RTI with the District Election Officer','Visit nearest Electoral Registration Office for voter ID issues'],
    updated_at = NOW()
WHERE code = 'ELECTION_ISSUE';

UPDATE incident_categories SET
    keywords = ARRAY['tax','income tax','GST','property tax','ITR','refund','assessment','notice','scrutiny','tax return','TDS','advance tax','tax evasion','GST return','GSTN','sales tax','excise'],
    citizen_actions = ARRAY['File grievance on Income Tax portal: incometax.gov.in','Use GST grievance mechanism on GSTN portal','For property tax: contact municipal corporation tax department','File appeal with Commissioner of Income Tax (Appeals)','Use Aaykar Seva Kendra for in-person grievances'],
    updated_at = NOW()
WHERE code = 'TAX_GRIEVANCE';

UPDATE incident_categories SET
    keywords = ARRAY['land','property','registration','mutation','encroachment','land acquisition','RERA','real estate','builder','flat','apartment','possession','land record','7/12','katha','patta','khatauni','survey','map','plot','revenue','tehsildar','patwari'],
    citizen_actions = ARRAY['File complaint on state RERA authority portal','Contact Sub-Registrar/Tehsildar for land record issues','Use DILRMS portal for digital land records','File RTI with Revenue Department for land acquisition details','For builder disputes: approach Consumer Forum or RERA'],
    updated_at = NOW()
WHERE code = 'LAND_RECORD_ISSUE';

UPDATE incident_categories SET
    keywords = ARRAY['education','school','teacher','college','university','admission','fee','scholarship','mid-day meal','Sarva Shiksha','CBSE','ICSE','state board','UGC','AICTE','NAAC','school infrastructure','classroom','library','laboratory'],
    citizen_actions = ARRAY['File complaint with school principal/college administration','Use state education department grievance portal','For scholarships: apply on National Scholarship Portal','File RTI with the institution or education department','For UGC/AICTE issues: file on their grievance portals'],
    updated_at = NOW()
WHERE code = 'EDUCATION_ISSUE';

UPDATE incident_categories SET
    keywords = ARRAY['environment','pollution','air pollution','water pollution','noise pollution','industrial waste','emission','AQI','smog','CPCB','SPCB','environment clearance','EIA','tree cutting','deforestation','waste dumping','plastic','hazardous waste','river pollution','lake','wetland','biodiversity'],
    citizen_actions = ARRAY['File complaint on CPCB/SPCB online portal','Use Sameer app for air quality complaints','Report to National Green Tribunal for major violations','File RTI with State Pollution Control Board','Contact District Forest Officer for tree cutting issues'],
    updated_at = NOW()
WHERE code = 'ENVIRONMENT_ISSUE';

UPDATE incident_categories SET
    keywords = ARRAY['pension','retirement','EPFO','provident fund','PF','EPS','gratuity','superannuation','NPS','national pension','PPO','pension scheme','old age','social security'],
    citizen_actions = ARRAY['Use EPFO grievance portal: epfigms.gov.in','Call EPFO helpline 1800-118-005 for PF issues','For NPS: use NPS grievance portal on npscra.nsdl.com','File RTI with EPFO regional office','Approach EPFO Appellate Tribunal for unresolved issues'],
    updated_at = NOW()
WHERE code = 'PENSION_ISSUE';

UPDATE incident_categories SET
    keywords = ARRAY['food','ration','PDS','public distribution','fair price shop','FPS','ration card','wheat','rice','sugar','kerosene','LPG','food security','NFSA','Anna canteen','mid-day meal','ration shop','food grain','subsidy','BPL','AAY','PHH'],
    citizen_actions = ARRAY['Complain to District Food and Supplies Officer','Use state PDS grievance portal','Call PDS helpline 1967','File RTI with Food and Supplies Department','Report on NFSA grievance portal or state food commission'],
    updated_at = NOW()
WHERE code = 'FOOD_RATION_ISSUE';

UPDATE incident_categories SET
    keywords = ARRAY['bank','banking','loan','EMI','account','ATM','UPI','NEFT','RTGS','digital payment','cheque','debit card','credit card','fraud','unauthorized transaction','balance','KYC','branch','banking ombudsman','RBI','transaction failure'],
    citizen_actions = ARRAY['First raise issue with your bank branch or customer care','If unresolved in 30 days file with Banking Ombudsman','Use RBI integrated ombudsman scheme portal','File complaint on CMS of RBI','For UPI issues: also file on NPCI portal'],
    updated_at = NOW()
WHERE code = 'BANKING_ISSUE';

UPDATE incident_categories SET
    keywords = ARRAY['employment','job','unemployment','skill','vocational','career','placement','recruitment','government job','sarkari naukri','UPSC','SSC','state PSC','apprenticeship','mgnrega','MNREGA','job card','wage','labour','worker','contractor','minimum wage'],
    citizen_actions = ARRAY['For MGNREGA issues: contact Gram Panchayat or BDO','File on state employment exchange portal','For government recruitment: file RTI with recruiting body','Use Shram Suvidha portal for labour issues','For unpaid wages: file complaint with Labour Commissioner'],
    updated_at = NOW()
WHERE code = 'EMPLOYMENT_ISSUE';

UPDATE incident_categories SET
    keywords = ARRAY['crime','police','FIR','complaint','theft','robbery','assault','harassment','cybercrime','missing','accident','law and order','law enforcement','traffic','traffic police','cop','thanedar','SHO','100','112','helpline','women helpline','child helpline','domestic violence','eve teasing','stalking'],
    citizen_actions = ARRAY['Call 112 or 100 for immediate emergencies','File FIR at nearest police station — it is your constitutional right','Use state police online FIR/complaint portal','For cybercrime: file on cybercrime.gov.in','For women: call 181 or 1091','File RTI with police station for investigation status'],
    updated_at = NOW()
WHERE code = 'LAW_AND_ORDER';

UPDATE incident_categories SET
    keywords = ARRAY['transport','bus','metro','train','auto','rickshaw','cab','taxi','uber','ola','public transport','bus stop','metro station','railway','IRCTC','ticket','reservation','waiting list','Tatkal','platform','coach','delay','cancellation','refund','bus pass','transport department','RTO','driving license','vehicle registration'],
    citizen_actions = ARRAY['For railways: file on IRCTC portal or call 139','Use Rail Madad portal: railmadad.indianrailways.gov.in','For bus issues: contact state road transport corporation','For metro: use respective metro rail grievance portal','For auto/taxi overcharging: note vehicle number and file with RTO','For DL/registration: use Parivahan Sewa parivahan.gov.in'],
    updated_at = NOW()
WHERE code = 'PUBLIC_TRANSPORT';

UPDATE incident_categories SET
    keywords = ARRAY['agriculture','farmer','crop','irrigation','fertilizer','pesticide','seed','MSP','minimum support price','mandi','APMC','kisan','loan waiver','crop insurance','PM-KISAN','soil health','organic farming','agri market','procurement','cold storage','farm loan','kisan credit card'],
    citizen_actions = ARRAY['Contact Agriculture Department or Krishi Vigyan Kendra','Use PM-KISAN grievance portal: pmkisan.gov.in','For crop insurance: file on PM Fasal Bima Yojana portal','File RTI with district agriculture officer for MSP data','For irrigation: contact Water Resources Department','Call Kisan Call Center: 1800-180-1551'],
    updated_at = NOW()
WHERE code = 'AGRICULTURE_ISSUE';

UPDATE incident_categories SET
    keywords = ARRAY['LPG','gas cylinder','cooking gas','HP Gas','Bharat Gas','Indane','gas connection','subsidy','PAHAL','gas agency','domestic gas','cylinder booking','gas leak','pipeline gas','PNG connection','city gas','IGL','Mahanagar Gas'],
    citizen_actions = ARRAY['Book/cancel cylinder via distributor portal or IVRS','For subsidy issues: check on mylpg.in','Complain to area LPG distributor — escalate to Area Manager','For gas leak emergencies: call distributor emergency number','File RTI with Ministry of Petroleum and Natural Gas'],
    updated_at = NOW()
WHERE code = 'DOMESTIC_LPG_ISSUE';

UPDATE incident_categories SET
    keywords = ARRAY['telecom','mobile','internet','broadband','Jio','Airtel','VI','BSNL','tower','network','call drop','5G','4G','data speed','landline','phone bill','recharge','DTH','set-top box','TRAI','bill dispute','wrong billing','connection','portability','MNP','SIM','activation'],
    citizen_actions = ARRAY['First complain to telecom operator customer care','If unresolved in 7 days use TRAI Public Grievance portal: tccms.gov.in','Call TRAI helpline or use MyCall app for call drops','File RTI with TRAI or Department of Telecommunications','For DTH issues: contact broadcaster or TRAI'],
    updated_at = NOW()
WHERE code = 'TELECOM_ISSUE';

UPDATE incident_categories SET
    keywords = ARRAY['woman','women','gender','domestic violence','dowry','harassment','sexual harassment','POSH','workplace harassment','rape','molestation','stalking','eve teasing','child marriage','female foeticide','gender discrimination','maternity','pregnancy','women safety','181','1091'],
    citizen_actions = ARRAY['Call 181 Women Helpline or 1091 Women in Distress','File FIR — police MUST register for cognizable offences against women','Use NCW complaint portal: ncw.nic.in','For workplace: file POSH complaint with Internal Complaints Committee','File RTI with District Women and Child Development Office'],
    updated_at = NOW()
WHERE code = 'WOMEN_SAFETY_ISSUE';

UPDATE incident_categories SET
    keywords = ARRAY['child','children','child labour','child abuse','child rights','adoption','orphan','anganwadi','ICDS','child education','child health','immunization','malnutrition','mid-day meal','child marriage','juvenile','child helpline','1098','NCPCR','child protection','trafficking'],
    citizen_actions = ARRAY['Call CHILDLINE 1098 for any child in need','File complaint with NCPCR','Contact District Child Protection Unit','File RTI with Women and Child Development Department','For child labour: report to Labour Commissioner'],
    updated_at = NOW()
WHERE code = 'CHILD_WELFARE_ISSUE';

UPDATE incident_categories SET
    keywords = ARRAY['housing','slum','rehabilitation','PMAY','housing scheme','flat','apartment','builder','construction','RERA','possession','rent','tenant','landlord','eviction','rent agreement','affordable housing','shelter','homeless','night shelter','housing society','CHS','cooperative housing'],
    citizen_actions = ARRAY['File complaint on state RERA portal','For PMAY: track on pmaymis.gov.in or contact Urban Local Body','For rent disputes: approach Rent Controller or District Forum','File RTI with Housing Department','For cooperative housing: approach Registrar of Cooperative Societies'],
    updated_at = NOW()
WHERE code = 'HOUSING_ISSUE';

UPDATE incident_categories SET
    keywords = ARRAY['digital','internet','wifi','broadband','website','online','e-governance','DigiLocker','UMANG','Aadhaar','UPI','digital India','cyber crime','online fraud','phishing','hacking','data breach','privacy','IT act','cert-in','online harassment','social media','fake news','deepfake','digital literacy'],
    citizen_actions = ARRAY['For cybercrime: file on cybercrime.gov.in','Report phishing/fraud to CERT-In','For Aadhaar issues: file on uidai.gov.in grievance portal','For online financial fraud: inform bank and RBI ombudsman','File RTI with Ministry of Electronics and IT'],
    updated_at = NOW()
WHERE code = 'DIGITAL_SERVICES_ISSUE';


-- ============================================================================
-- PART 3: INSERT NEW CATEGORIES (13 new ones)
-- ============================================================================

INSERT INTO incident_categories (name, code, description, department_id, keywords, citizen_actions, created_at, updated_at)
VALUES
    ('Insurance Grievance', 'INSURANCE_ISSUE',
     'Complaints related to life insurance, health insurance, motor insurance claim rejections, delays, or policy disputes.',
     (SELECT id FROM departments WHERE code = 'RBI_BANKING_CENTRAL' LIMIT 1),
     ARRAY['insurance','life insurance','health insurance','motor insurance','claim','policy','premium','IRDAI','LIC','HDFC Life','ICICI Prudential','SBI Life','claim rejection','claim delay','policy surrender','maturity','term plan','ULIP','endowment','insurance ombudsman'],
     ARRAY['First raise grievance with the insurance company','If unresolved in 30 days approach IRDAI IGMS','File with Insurance Ombudsman','For LIC: use LIC grievance portal at licindia.in','File RTI with IRDAI for regulatory information'],
     NOW(), NOW()),

    ('Public Distribution System', 'PDS_ISSUE',
     'Issues with ration shops, food grain distribution, PDS cards, subsidy distribution under NFSA.',
     (SELECT id FROM departments WHERE code = 'CONSUMER_AFFAIRS_CENTRAL' LIMIT 1),
     ARRAY['PDS','public distribution system','ration shop','fair price shop','FPS','ration card','food grain','wheat','rice','sugar','kerosene allocation','NFSA','food security act','BPL card','AAY card','PHH card','ration dealer','black marketing','PDS grievance','food inspector'],
     ARRAY['Complain to District Food and Supplies Controller','Use state PDS portal for online grievances','Call PDS helpline 1967','File RTI with Food and Civil Supplies Department','Report to State Food Commission for systemic issues'],
     NOW(), NOW()),

    ('Street Lighting', 'STREET_LIGHTING',
     'Non-functional or missing street lights in public areas, roads, parks, and residential areas.',
     (SELECT id FROM departments WHERE code = 'MOHUA_CENTRAL' LIMIT 1),
     ARRAY['street light','streetlight','street lamp','road light','pole light','no light','dark road','broken light','LED street light','solar light','park light','footpath light','area light','public lighting'],
     ARRAY['Report to municipal corporation or nagar nigam','Use city mobile app or 311 helpline','File complaint on state urban development portal','Contact local ward corporator','File RTI with Municipal Engineering Department'],
     NOW(), NOW()),

    ('Noise Pollution', 'NOISE_POLLUTION',
     'Excessive noise from construction, loudspeakers, traffic, industries, or public events.',
     (SELECT id FROM departments WHERE code = 'MOEFCC_CENTRAL' LIMIT 1),
     ARRAY['noise','noise pollution','loudspeaker','construction noise','traffic noise','industrial noise','horn','DJ','party noise','temple noise','firecracker','diwali','noise limit','decibel','silence zone','night noise'],
     ARRAY['File complaint with local police station','Complain to State Pollution Control Board','For construction noise: complain to municipal corporation','Use Sameer app or CPCB portal','File RTI with SPCB for noise monitoring data'],
     NOW(), NOW()),

    ('Stray Animal Menace', 'STRAY_ANIMAL',
     'Issues related to stray dogs, cattle on roads, or animal cruelty/neglect.',
     (SELECT id FROM departments WHERE code = 'MOHUA_CENTRAL' LIMIT 1),
     ARRAY['stray','stray dog','street dog','dog bite','rabies','stray cattle','cow on road','animal nuisance','monkey menace','animal cruelty','animal rescue','SPCA','animal shelter','sterilization','ABC program'],
     ARRAY['For dog bites: visit nearest hospital immediately','Contact municipal ABC program','Call city animal helpline','File RTI with Municipal Health Department on ABC status','For cruelty: file FIR and contact SPCA'],
     NOW(), NOW()),

    ('Certificate and Document Issuance', 'CERTIFICATE_ISSUE',
     'Delays, corruption, or denial in issuance of certificates: caste, income, domicile, birth, death, marriage.',
     (SELECT id FROM departments WHERE code = 'MHA_POLICE_CENTRAL' LIMIT 1),
     ARRAY['certificate','caste certificate','income certificate','domicile','birth certificate','death certificate','marriage certificate','character certificate','migration certificate','nativity','residence certificate','OBC certificate','SC/ST certificate','EWS certificate','aadhaar card','PAN card','passport','tahsildar','collector','gazette'],
     ARRAY['Apply online through state e-District portal','Track status on state service delivery portal','If delayed: file grievance with District Collector','File RTI with concerned tehsil/revenue office','Use Jan Soochna or similar transparency portals'],
     NOW(), NOW()),

    ('Flood and Disaster Management', 'FLOOD_DISASTER',
     'Flood relief, disaster response, dam management, and natural disaster preparedness issues.',
     (SELECT id FROM departments WHERE code = 'MHA_POLICE_CENTRAL' LIMIT 1),
     ARRAY['flood','flood relief','dam','embankment','disaster','NDMA','SDMA','cyclone','earthquake','landslide','cloudburst','flood rescue','relief camp','relief material','compensation','NDRF','flood warning','water logging','monsoon','flood prone'],
     ARRAY['For rescue: call 112 (NDRF/SDRF)','Register for compensation with District Collector','File RTI with NDMA/SDMA for preparedness plans','Use state disaster management portal','For dam safety: contact Central Water Commission'],
     NOW(), NOW()),

    ('Consumer Protection', 'CONSUMER_PROTECTION',
     'Product defects, service deficiencies, unfair trade practices, and consumer rights violations.',
     (SELECT id FROM departments WHERE code = 'CONSUMER_AFFAIRS_CENTRAL' LIMIT 1),
     ARRAY['consumer','consumer complaint','defective product','refund','replacement','warranty','guarantee','misleading','advertising','overcharging','MRP','maximum retail price','expiry date','adulteration','e-commerce','Amazon','Flipkart','consumer court','consumer forum','CCPA'],
     ARRAY['Call National Consumer Helpline: 1800-11-4000','Use consumeraffairs.gov.in/echannel','File case in Consumer Disputes Redressal Commission','For e-commerce: use platform grievance first then consumer forum','File RTI with CCPA'],
     NOW(), NOW()),

    ('Senior Citizen Welfare', 'SENIOR_CITIZEN',
     'Issues related to pension, healthcare, elder abuse, and social security for senior citizens.',
     (SELECT id FROM departments WHERE code = 'SOCIAL_JUSTICE_CENTRAL' LIMIT 1),
     ARRAY['senior citizen','elderly','old age','pension','elder abuse','elder care','old age home','geriatric','senior','retired','VRS','voluntary retirement','maintenance','parents','elder helpline','14567'],
     ARRAY['Call Senior Citizen Helpline: 14567','File complaint with District Social Welfare Officer','For elder abuse: file FIR (Maintenance Act)','Use Senior Citizens portal on socialjustice.gov.in','File RTI with Ministry of Social Justice'],
     NOW(), NOW()),

    ('Disability Rights and Access', 'DISABILITY_ISSUE',
     'Accessibility barriers, disability certificate delays, and denial of rights under RPwD Act 2016.',
     (SELECT id FROM departments WHERE code = 'SOCIAL_JUSTICE_CENTRAL' LIMIT 1),
     ARRAY['disability','disabled','handicapped','differently abled','accessibility','ramp','wheelchair','braille','sign language','disability certificate','UDID','specially abled','visual impairment','hearing impairment','autism','disability pension','RPwD','divyang'],
     ARRAY['Apply for UDID on swavlambancard.gov.in','File complaint with State Commissioner for PwDs','Use Accessible India grievance portal','File RTI with DEPwD','Approach Chief Commissioner for PwDs'],
     NOW(), NOW()),

    ('Court and Legal System', 'LEGAL_SYSTEM',
     'Issues related to case delays, access to justice, legal aid, and judicial accountability.',
     (SELECT id FROM departments WHERE code = 'MHA_POLICE_CENTRAL' LIMIT 1),
     ARRAY['court','judge','case','litigation','justice','lawyer','advocate','bail','trial','verdict','high court','supreme court','district court','fast track court','case pending','e-court','ecourts','legal aid','NALSA','lok adalat'],
     ARRAY['Track case status on ecourts.gov.in','Apply for legal aid through NALSA or State Legal Services','Approach Lok Adalat for dispute resolution','File RTI with court administration','Contact Chief Justice for judicial accountability'],
     NOW(), NOW()),

    ('Drug and Substance Abuse', 'DRUG_ABUSE',
     'Issues related to drug trafficking, substance abuse, rehabilitation, and NDPS Act enforcement.',
     (SELECT id FROM departments WHERE code = 'MHA_POLICE_CENTRAL' LIMIT 1),
     ARRAY['drug','drugs','narcotics','substance abuse','drug trafficking','NDPS','cannabis','ganja','drug peddler','drug addiction','rehabilitation','de-addiction','drug menace','pharmaceutical','opioid','NCB'],
     ARRAY['Report drug trafficking to police or call 112','Report to Narcotics Control Bureau','For rehabilitation: contact state Social Welfare Department','Use Nasha Mukt Bharat portal','File RTI with Ministry of Social Justice'],
     NOW(), NOW()),

    ('Minimum Wage and Labour Rights', 'MINIMUM_WAGE',
     'Issues related to unpaid wages, minimum wage violations, overtime, and worker exploitation.',
     (SELECT id FROM departments WHERE code = 'LABOUR_CENTRAL' LIMIT 1),
     ARRAY['minimum wage','wage','salary','unpaid','overtime','labour','labor','worker','employee','contractor','labour law','ESIC','EPFO','gratuity','bonus','PF','maternity benefit','child labour','bonded labour','labour inspector','trade union','industrial dispute'],
     ARRAY['File complaint with Labour Commissioner','Use Shram Suvidha Portal: shramsuvidha.gov.in','For EPFO: file on epfigms.gov.in','For ESIC: file on ESIC portal','For bonded/child labour: call 1098 or 112'],
     NOW(), NOW()),

    ('Public Park and Recreation', 'PARK_RECREATION',
     'Maintenance, access, and encroachment of public parks, playgrounds, and recreational spaces.',
     (SELECT id FROM departments WHERE code = 'MOHUA_CENTRAL' LIMIT 1),
     ARRAY['park','garden','playground','recreation','sports ground','stadium','swimming pool','public space','green space','tree','garden maintenance','encroachment','park entry','jogging','walking track','open gym','community hall','library','museum'],
     ARRAY['Complain to municipal Parks and Gardens department','Use city civic complaint app or 311','Contact local ward corporator','File RTI with Urban Development Dept for park budget','For encroachment: also file with District Collector'],
     NOW(), NOW()),

    ('Fire Safety', 'FIRE_SAFETY',
     'Fire safety violations, lack of fire equipment, and fire emergency response issues.',
     (SELECT id FROM departments WHERE code = 'MHA_POLICE_CENTRAL' LIMIT 1),
     ARRAY['fire','fire safety','fire extinguisher','fire escape','fire alarm','fire brigade','fire station','fire NOC','fire audit','fire emergency','building fire','fire hazard','short circuit fire','firecracker','fire department','101'],
     ARRAY['For fire emergency: call 101','Report violations to local fire department/municipal corporation','File RTI with Fire Dept for building NOC status','For residential buildings: approach RWA','For commercial: check fire NOC with municipal fire dept'],
     NOW(), NOW())
ON CONFLICT DO NOTHING;


-- ============================================================================
-- PART 4: INCIDENT_CATEGORY_DEPARTMENTS LINKAGES
-- Table schema: id, incident_category_id, department_id, responsibility_level
-- ============================================================================

INSERT INTO incident_category_departments (incident_category_id, department_id, responsibility_level)
SELECT ic.id, d.id, 'PRIMARY'
FROM incident_categories ic, departments d
WHERE ic.code IN ('ELECTRICITY_FAILURE', 'POWER_FAILURE') AND d.code = 'MORTH_CENTRAL'
ON CONFLICT DO NOTHING;

INSERT INTO incident_category_departments (incident_category_id, department_id, responsibility_level)
SELECT ic.id, d.id, 'PRIMARY'
FROM incident_categories ic, departments d
WHERE ic.code = 'ENVIRONMENT_ISSUE' AND d.code = 'MOEFCC_CENTRAL'
ON CONFLICT DO NOTHING;

INSERT INTO incident_category_departments (incident_category_id, department_id, responsibility_level)
SELECT ic.id, d.id, 'PRIMARY'
FROM incident_categories ic, departments d
WHERE ic.code = 'PUBLIC_TRANSPORT' AND d.code = 'RAILWAYS_CENTRAL'
ON CONFLICT DO NOTHING;

INSERT INTO incident_category_departments (incident_category_id, department_id, responsibility_level)
SELECT ic.id, d.id, 'PRIMARY'
FROM incident_categories ic, departments d
WHERE ic.code = 'PUBLIC_TRANSPORT' AND d.code = 'MORTH_CENTRAL'
ON CONFLICT DO NOTHING;

INSERT INTO incident_category_departments (incident_category_id, department_id, responsibility_level)
SELECT ic.id, d.id, 'PRIMARY'
FROM incident_categories ic, departments d
WHERE ic.code = 'PUBLIC_TRANSPORT' AND d.code = 'DOT_CENTRAL'
ON CONFLICT DO NOTHING;

INSERT INTO incident_category_departments (incident_category_id, department_id, responsibility_level)
SELECT ic.id, d.id, 'PRIMARY'
FROM incident_categories ic, departments d
WHERE ic.code = 'AGRICULTURE_ISSUE' AND d.code = 'AGRI_CENTRAL'
ON CONFLICT DO NOTHING;

INSERT INTO incident_category_departments (incident_category_id, department_id, responsibility_level)
SELECT ic.id, d.id, 'PRIMARY'
FROM incident_categories ic, departments d
WHERE ic.code = 'BANKING_ISSUE' AND d.code = 'RBI_BANKING_CENTRAL'
ON CONFLICT DO NOTHING;

INSERT INTO incident_category_departments (incident_category_id, department_id, responsibility_level)
SELECT ic.id, d.id, 'PRIMARY'
FROM incident_categories ic, departments d
WHERE ic.code = 'INSURANCE_ISSUE' AND d.code = 'RBI_BANKING_CENTRAL'
ON CONFLICT DO NOTHING;

INSERT INTO incident_category_departments (incident_category_id, department_id, responsibility_level)
SELECT ic.id, d.id, 'PRIMARY'
FROM incident_categories ic, departments d
WHERE ic.code = 'DOMESTIC_LPG_ISSUE' AND d.code = 'PNG_CENTRAL'
ON CONFLICT DO NOTHING;

INSERT INTO incident_category_departments (incident_category_id, department_id, responsibility_level)
SELECT ic.id, d.id, 'PRIMARY'
FROM incident_categories ic, departments d
WHERE ic.code IN ('FOOD_RATION_ISSUE', 'PDS_ISSUE') AND d.code = 'CONSUMER_AFFAIRS_CENTRAL'
ON CONFLICT DO NOTHING;

INSERT INTO incident_category_departments (incident_category_id, department_id, responsibility_level)
SELECT ic.id, d.id, 'PRIMARY'
FROM incident_categories ic, departments d
WHERE ic.code = 'TELECOM_ISSUE' AND d.code = 'DOT_CENTRAL'
ON CONFLICT DO NOTHING;

INSERT INTO incident_category_departments (incident_category_id, department_id, responsibility_level)
SELECT ic.id, d.id, 'PRIMARY'
FROM incident_categories ic, departments d
WHERE ic.code = 'WOMEN_SAFETY_ISSUE' AND d.code = 'WCD_CENTRAL'
ON CONFLICT DO NOTHING;

INSERT INTO incident_category_departments (incident_category_id, department_id, responsibility_level)
SELECT ic.id, d.id, 'PRIMARY'
FROM incident_categories ic, departments d
WHERE ic.code = 'CHILD_WELFARE_ISSUE' AND d.code = 'WCD_CENTRAL'
ON CONFLICT DO NOTHING;

INSERT INTO incident_category_departments (incident_category_id, department_id, responsibility_level)
SELECT ic.id, d.id, 'PRIMARY'
FROM incident_categories ic, departments d
WHERE ic.code = 'HOUSING_ISSUE' AND d.code = 'MOHUA_CENTRAL'
ON CONFLICT DO NOTHING;

INSERT INTO incident_category_departments (incident_category_id, department_id, responsibility_level)
SELECT ic.id, d.id, 'PRIMARY'
FROM incident_categories ic, departments d
WHERE ic.code IN ('EMPLOYMENT_ISSUE', 'MINIMUM_WAGE') AND d.code = 'LABOUR_CENTRAL'
ON CONFLICT DO NOTHING;

INSERT INTO incident_category_departments (incident_category_id, department_id, responsibility_level)
SELECT ic.id, d.id, 'PRIMARY'
FROM incident_categories ic, departments d
WHERE ic.code IN ('LAW_AND_ORDER', 'LEGAL_SYSTEM', 'DRUG_ABUSE', 'FIRE_SAFETY', 'CERTIFICATE_ISSUE', 'FLOOD_DISASTER') AND d.code = 'MHA_POLICE_CENTRAL'
ON CONFLICT DO NOTHING;

INSERT INTO incident_category_departments (incident_category_id, department_id, responsibility_level)
SELECT ic.id, d.id, 'PRIMARY'
FROM incident_categories ic, departments d
WHERE ic.code = 'DIGITAL_SERVICES_ISSUE' AND d.code = 'DOT_CENTRAL'
ON CONFLICT DO NOTHING;

INSERT INTO incident_category_departments (incident_category_id, department_id, responsibility_level)
SELECT ic.id, d.id, 'PRIMARY'
FROM incident_categories ic, departments d
WHERE ic.code = 'NOISE_POLLUTION' AND d.code = 'MOEFCC_CENTRAL'
ON CONFLICT DO NOTHING;

INSERT INTO incident_category_departments (incident_category_id, department_id, responsibility_level)
SELECT ic.id, d.id, 'PRIMARY'
FROM incident_categories ic, departments d
WHERE ic.code = 'CONSUMER_PROTECTION' AND d.code = 'CONSUMER_AFFAIRS_CENTRAL'
ON CONFLICT DO NOTHING;

INSERT INTO incident_category_departments (incident_category_id, department_id, responsibility_level)
SELECT ic.id, d.id, 'PRIMARY'
FROM incident_categories ic, departments d
WHERE ic.code IN ('SENIOR_CITIZEN', 'DISABILITY_ISSUE') AND d.code = 'SOCIAL_JUSTICE_CENTRAL'
ON CONFLICT DO NOTHING;

INSERT INTO incident_category_departments (incident_category_id, department_id, responsibility_level)
SELECT ic.id, d.id, 'PRIMARY'
FROM incident_categories ic, departments d
WHERE ic.code = 'STREET_LIGHTING' AND d.code = 'MOHUA_CENTRAL'
ON CONFLICT DO NOTHING;

INSERT INTO incident_category_departments (incident_category_id, department_id, responsibility_level)
SELECT ic.id, d.id, 'PRIMARY'
FROM incident_categories ic, departments d
WHERE ic.code = 'STRAY_ANIMAL' AND d.code = 'MOHUA_CENTRAL'
ON CONFLICT DO NOTHING;

INSERT INTO incident_category_departments (incident_category_id, department_id, responsibility_level)
SELECT ic.id, d.id, 'PRIMARY'
FROM incident_categories ic, departments d
WHERE ic.code = 'PARK_RECREATION' AND d.code = 'MOHUA_CENTRAL'
ON CONFLICT DO NOTHING;

INSERT INTO incident_category_departments (incident_category_id, department_id, responsibility_level)
SELECT ic.id, d.id, 'PRIMARY'
FROM incident_categories ic, departments d
WHERE ic.code = 'CORRUPTION' AND d.code = 'MHA_POLICE_CENTRAL'
ON CONFLICT DO NOTHING;

INSERT INTO incident_category_departments (incident_category_id, department_id, responsibility_level)
SELECT ic.id, d.id, 'PRIMARY'
FROM incident_categories ic, departments d
WHERE ic.code IN ('EDUCATION_ISSUE', 'EXAM_IRREGULARITY') AND d.code = 'SCHOOL_EDU_CENTRAL'
ON CONFLICT DO NOTHING;