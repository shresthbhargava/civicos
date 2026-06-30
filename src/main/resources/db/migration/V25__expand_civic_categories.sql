-- ============================================
-- PART 1: NEW CENTRAL DEPARTMENTS
-- ============================================
INSERT INTO departments (code, name, jurisdiction_level, ministry, website_url, complaint_portal_url) VALUES
                                                                                                          ('MIN_HOME_AFFAIRS_CENTRAL', 'Ministry of Home Affairs', 'CENTRAL', 'Ministry of Home Affairs', 'https://mha.gov.in', 'https://pgportal.gov.in'),
                                                                                                          ('MIN_FINANCE_CENTRAL', 'Ministry of Finance', 'CENTRAL', 'Ministry of Finance', 'https://finmin.gov.in', 'https://cpgramsb.gov.in'),
                                                                                                          ('MIN_AGRICULTURE_CENTRAL', 'Ministry of Agriculture & Farmers Welfare', 'CENTRAL', 'Ministry of Agriculture & Farmers Welfare', 'https://agricoop.gov.in', 'https://pgportal.gov.in'),
                                                                                                          ('MIN_RAILWAYS_CENTRAL', 'Ministry of Railways', 'CENTRAL', 'Ministry of Railways', 'https://indianrailways.gov.in', 'https://railmadad.indianrailways.gov.in'),
                                                                                                          ('MIN_WOMEN_CHILD_CENTRAL', 'Ministry of Women and Child Development', 'CENTRAL', 'Ministry of Women and Child Development', 'https://wcd.nic.in', 'https://pgportal.gov.in'),
                                                                                                          ('MIN_LAW_CENTRAL', 'Ministry of Law and Justice', 'CENTRAL', 'Ministry of Law and Justice', 'https://lawmin.gov.in', 'https://pgportal.gov.in'),
                                                                                                          ('MIN_PETROLEUM_CENTRAL', 'Ministry of Petroleum and Natural Gas', 'CENTRAL', 'Ministry of Petroleum and Natural Gas', 'https://petroleum.gov.in', 'https://pgportal.gov.in'),
                                                                                                          ('MIN_SOCIAL_JUSTICE_CENTRAL', 'Ministry of Social Justice and Empowerment', 'CENTRAL', 'Ministry of Social Justice and Empowerment', 'https://socialjustice.gov.in', 'https://pgportal.gov.in'),
                                                                                                          ('MIN_SKILL_CENTRAL', 'Ministry of Skill Development & Entrepreneurship', 'CENTRAL', 'Ministry of Skill Development & Entrepreneurship', 'https://msde.gov.in', 'https://pgportal.gov.in'),
                                                                                                          ('MIN_CIVIL_AVIATION_CENTRAL', 'Ministry of Civil Aviation', 'CENTRAL', 'Ministry of Civil Aviation', 'https://civilaviation.gov.in', 'https://pgportal.gov.in'),
                                                                                                          ('MIN_PORT_SHIPPING_CENTRAL', 'Ministry of Ports, Shipping & Waterways', 'CENTRAL', 'Ministry of Ports, Shipping & Waterways', 'https://shipmin.gov.in', 'https://pgportal.gov.in'),
                                                                                                          ('MIN_COAL_MINES_CENTRAL', 'Ministry of Coal and Mines', 'CENTRAL', 'Ministry of Coal and Mines', 'https://coal.gov.in', 'https://pgportal.gov.in')
    ON CONFLICT (code) DO NOTHING;

-- ============================================
-- PART 2: NEW CATEGORIES (15 new)
-- ============================================
INSERT INTO incident_categories (code, name, description, department_id, keywords, citizen_actions) VALUES

                                                                                                        ('POLICE_LAW_ORDER', 'Police and Law Order Issues',
                                                                                                         'Complaints related to police inaction, FIR refusal, corruption, law and order, and public safety.',
                                                                                                         (SELECT id FROM departments WHERE code = 'MIN_HOME_AFFAIRS_CENTRAL'),
                                                                                                         ARRAY['police','fir','crime','law and order','law enforcement','complaint','harassment','extortion','cops','thanedar','thana','refusal to file fir','zero fir','police brutality','custodial death','missing person','theft','robbery','burglary','public safety','riot','communal violence','goonda','rowdy'],
                                                                                                         ARRAY['File FIR at nearest police station or online via state portal','If FIR refused, approach Superintendent of Police','File complaint with State Human Rights Commission','Approach Lokayukta for corruption against police','File RTI seeking action taken report','Contact NHRC for custodial deaths or police brutality']),

                                                                                                        ('PUBLIC_TRANSPORT', 'Public Transport Issues',
                                                                                                         'Issues with bus services, metro, auto-rickshaws, taxis, fare disputes, and safety.',
                                                                                                         (SELECT id FROM departments WHERE code = 'MIN_HOUSING_CENTRAL'),
                                                                                                         ARRAY['bus','metro','train','railway','auto','rickshaw','taxi','cab','ola','uber','public transport','fare','overcharging','route','stop','station','crowding','bus pass','season ticket','rto','regional transport','driving license','vehicle registration','roadways','state transport','conductor','driver'],
                                                                                                         ARRAY['File complaint with State Transport Department or RTO','Use state transport corporation online portal','File RTI regarding route planning and safety','Report overcharging to Consumer Forum','Contact District Transport Officer','Use CM helpline or state grievance portal']),

                                                                                                        ('BANKING_FRAUD', 'Banking Fraud and Financial Scam',
                                                                                                         'Banking fraud, UPI scams, loan harassment, ATM issues, and financial irregularities.',
                                                                                                         (SELECT id FROM departments WHERE code = 'MIN_FINANCE_CENTRAL'),
                                                                                                         ARRAY['bank','banking','fraud','scam','upi','atm','loan','emi','interest rate','cheque','debit card','credit card','net banking','phishing','cyber fraud','digital payment','neft','rtgs','account frozen','unauthorized transaction','branch','kyc','insurance fraud','mutual fund','chit fund','ponzi','recovery agent','harassment by bank','rbi','reserve bank'],
                                                                                                         ARRAY['File complaint with bank and escalate to nodal officer','Lodge complaint on RBI Banking Ombudsman portal','Report cyber fraud to cybercrime.gov.in','File FIR for fraud/scam','Approach Consumer Forum for banking deficiencies','File RTI with RBI regarding actions taken']),

                                                                                                        ('EMPLOYMENT_ISSUE', 'Employment and Recruitment Issues',
                                                                                                         'Government recruitment scams, job frauds, salary delays, and labour rights.',
                                                                                                         (SELECT id FROM departments WHERE code = 'MIN_LABOUR_CENTRAL'),
                                                                                                         ARRAY['job','employment','recruitment','unemployment','salary','wage','labour','contract','outsourcing','appointment','selection','interview','merit list','reservation','quota','temporary','permanent','termination','retrenchment','pf','esi','gratuity','bonus','overtime','minimum wage','child labour','bonded labour','trade union','strike','pay commission','arrear','dearness allowance','government job','sarkari naukri'],
                                                                                                         ARRAY['File complaint with District Labour Commissioner','Approach EPFO for PF issues','File RTI with recruiting authority','Use PM Shram Yogi Maandhan portal','Contact State Labour Department','Approach Labour Court for disputes']),

                                                                                                        ('LAND_AGRICULTURE', 'Land and Agriculture Issues',
                                                                                                         'Land acquisition, farmer distress, crop damage, MSP, land records, and agricultural services.',
                                                                                                         (SELECT id FROM departments WHERE code = 'MIN_AGRICULTURE_CENTRAL'),
                                                                                                         ARRAY['land','farmer','agriculture','crop','msp','minimum support price','acquisition','patta','mutation','registration','revenue','kisan','fertilizer','seed','irrigation','canal','drought','flood','compensation','landlord','tenant','encroachment','survey number','land record','cattle','cooperative','mandi','apmc','agri market','soil testing','kisan credit card','loan waiver'],
                                                                                                         ARRAY['File complaint with District Collector or Revenue Officer','Approach State Agriculture Department for compensation','Use Kisan Call Center 1800-180-1551','File RTI with Revenue Department regarding land records','Contact State Farmers Commission for MSP issues','Approach NHRC for land rights violations']),

                                                                                                        ('WOMEN_SAFETY', 'Women Safety and Harassment',
                                                                                                         'Women harassment, domestic violence, workplace harassment, stalking, and gender discrimination.',
                                                                                                         (SELECT id FROM departments WHERE code = 'MIN_WOMEN_CHILD_CENTRAL'),
                                                                                                         ARRAY['women','harassment','domestic violence','stalking','eve teasing','molestation','sexual harassment','workplace harassment','gender discrimination','dowry','maintenance','child marriage','women safety','rape','acid attack','cyber stalking','maternity','pregnancy','posh','internal complaints committee','women helpline','181','shakti button'],
                                                                                                         ARRAY['Call Women Helpline 181 or 1091','File FIR at nearest police station','Contact State Women Commission','File complaint on NCW portal (ncwapps.nic.in)','Approach ICC for workplace harassment','File RTI with police regarding action taken']),

                                                                                                        ('TAX_ISSUE', 'Tax and GST Issues',
                                                                                                         'Income tax, GST refunds, tax assessments, and revenue department issues.',
                                                                                                         (SELECT id FROM departments WHERE code = 'MIN_FINANCE_CENTRAL'),
                                                                                                         ARRAY['tax','income tax','gst','gst refund','assessment','refund','itr','return','pan','aadhaar','tax department','survey','raid','notice','scrutiny','appeal','commissioner','cpc','goods and services tax','input tax credit','itc','gstn','eway bill','invoice','tax evasion','property tax','municipal tax','lpg subsidy'],
                                                                                                         ARRAY['File grievance on Income Tax portal (incometax.gov.in)','Use GST grievance mechanism on GSTN','File appeal with CIT (Appeals)','Approach Income Tax Ombudsman','File RTI with CBDT','Contact CPC for refund delays']),

                                                                                                        ('PASSPORT_IDENTITY', 'Passport and Identity Documents',
                                                                                                         'Passport delays, Aadhaar issues, voter ID, and identity document problems.',
                                                                                                         (SELECT id FROM departments WHERE code = 'MIN_HOME_AFFAIRS_CENTRAL'),
                                                                                                         ARRAY['passport','aadhaar','voter id','pan card','identity','uidai','enrollment','biometric','election commission','voter list','election card','driving license','birth certificate','death certificate','domicile','citizenship','passport seva','tatkal','police verification','passport delay','aadhaar update','mobile linking'],
                                                                                                         ARRAY['File complaint on Passport Seva portal','Lodge grievance with UIDAI for Aadhaar','Contact Election Commission for voter ID','File RTI with Regional Passport Officer','Approach District Collector','Use CPGRAMS portal']),

                                                                                                        ('MUNICIPAL_SERVICES', 'Municipal and Civic Services',
                                                                                                         'Street lights, drainage, garbage, stray animals, noise, and municipal infrastructure.',
                                                                                                         (SELECT id FROM departments WHERE code = 'MIN_HOUSING_CENTRAL'),
                                                                                                         ARRAY['drainage','street light','garbage','waste','stray dogs','stray animals','noise','noise pollution','construction','encroachment','parking','footpath','sewer','sewage','manhole','mosquito','dengue','malaria','fogging','municipal','corporation','municipality','ward','councillor','mayor','civic amenity','playground','park','tree cutting','hawker','street vendor','solid waste','public toilet','swachh'],
                                                                                                         ARRAY['File complaint with Municipal Corporation portal','Use state civic complaint apps','Call municipal helpline','File RTI with Municipal Commissioner','Contact Ward Councillor','Approach State Urban Development Department']),

                                                                                                        ('FUEL_LPG', 'Fuel, LPG and Petroleum Issues',
                                                                                                         'LPG supply, fuel prices, petrol pump fraud, and CNG issues.',
                                                                                                         (SELECT id FROM departments WHERE code = 'MIN_PETROLEUM_CENTRAL'),
                                                                                                         ARRAY['lpg','cylinder','gas','fuel','petrol','diesel','cng','petrol pump','adulteration','short supply','delivery','connection','subsidy','ujwala','pm ujjwala','kerosene','natural gas','oil','ioc','bpcl','hpcl','gas agency','distributor','booking','delay','refill','leakage'],
                                                                                                         ARRAY['File complaint with LPG distributor and escalate','Lodge complaint on Petroleum Ministry portal','Use HPCL/BPCL/IOCL customer care','File RTI with oil company','Contact District Supply Officer','Report petrol pump fraud']),

                                                                                                        ('ENVIRONMENT_FOREST', 'Environment and Forest Issues',
                                                                                                         'Tree cutting, forest encroachment, wildlife, pollution, and environmental violations.',
                                                                                                         (SELECT id FROM departments WHERE code = 'MIN_ENVIRONMENT_CENTRAL'),
                                                                                                         ARRAY['tree','forest','wildlife','pollution','environment','mining','quarry','river','lake','wetland','biodiversity','poaching','deforestation','environmental clearance','eia','plastic','emission','industrial pollution','air quality','water quality','noise','construction dust','coastal','nrega','green cover','tree cutting permission','forest land diversion','forest rights act','gram sabha'],
                                                                                                         ARRAY['File complaint with State Pollution Control Board','Report to State Forest Department','Contact Environment Ministry for clearance violations','File RTI regarding clearances','Approach National Green Tribunal','Contact State Biodiversity Board']),

                                                                                                        ('PDS_RATION', 'Public Distribution System Issues',
                                                                                                         'Ration cards, PDS supplies, food grain distribution, and subsidy schemes.',
                                                                                                         (SELECT id FROM departments WHERE code = 'MIN_RURAL_CENTRAL'),
                                                                                                         ARRAY['ration','pds','food grain','rice','wheat','sugar','kerosene','ration card','bpl','apl','aay','fair price','fps','public distribution','dealer','black market','hoarding','subsidy','midday meal','anganwadi','icds','antyodaya','food security','malnutrition'],
                                                                                                         ARRAY['File complaint with District Food and Supply Controller','Use state PDS grievance portal','Call 1800-180-2222 (FPS grievance)','File RTI with Food Department','Contact District Collector','Approach State Food Commission']),

                                                                                                        ('CASTE_CERTIFICATE', 'Caste Certificate and Reservation Issues',
                                                                                                         'Caste certificate delays, reservation disputes, and social justice issues.',
                                                                                                         (SELECT id FROM departments WHERE code = 'MIN_SOCIAL_JUSTICE_CENTRAL'),
                                                                                                         ARRAY['caste','certificate','reservation','quota','sc','st','obc','ews','economically weaker','scheduled caste','scheduled tribe','other backward','creamy layer','caste validity','social justice','empowerment','disability','specially abled','disability certificate','income certificate','domicile','minority'],
                                                                                                         ARRAY['File complaint with Tahsildar or SDM','Use state e-district portal','File RTI with Revenue Department','Contact State Social Justice Department','Approach NC for SC/ST','Contact NCBC for OBC issues']),

                                                                                                        ('RAILWAY_ISSUE', 'Railway Service Issues',
                                                                                                         'Train services, cleanliness, safety, ticketing, and railway infrastructure.',
                                                                                                         (SELECT id FROM departments WHERE code = 'MIN_RAILWAYS_CENTRAL'),
                                                                                                         ARRAY['railway','train','platform','ticket','reservation','waiting list','tatkal','cancellation','refund','coach','cleanliness','food','delay','late','accident','safety','overcrowding','unreserved','sleeper','ac','station','junction','railway crossing','foot over bridge','luggage','theft on train','rpf','railway police','concession','senior citizen','vande bharat','rajdhani','shatabdi'],
                                                                                                         ARRAY['File complaint on Rail Madad portal (railmadad.indianrailways.gov.in)','Call Railway Helpline 139','File RTI with Railway Board','Contact Station Master','Approach Railway Claims Tribunal','Tag Railway Ministry on X/Twitter']),

                                                                                                        ('HIGHER_EDUCATION', 'Higher Education and University Issues',
                                                                                                         'University administration, degrees, research, and higher education infrastructure.',
                                                                                                         (SELECT id FROM departments WHERE code = 'MIN_EDUCATION_CENTRAL'),
                                                                                                         ARRAY['university','college','degree','phd','research','vice chancellor','admission','entrance','cuet','neet pg','gate','cat','placement','campus','hostel','library','accreditation','naac','nirf','fee','scholarship','fellowship','ugc','aicte','registrar','exam result','marksheet','transcript','semester'],
                                                                                                         ARRAY['File complaint with University Registrar','Approach UGC for grievances','Use AICTE portal for technical education','File RTI with University','Contact State Higher Education Department','Approach NAAC for quality issues'])
    ON CONFLICT (code) DO NOTHING;

-- ============================================
-- PART 3: UPDATE EXISTING CATEGORIES WITH MORE KEYWORDS
-- ============================================
UPDATE incident_categories SET keywords = ARRAY[
    'electricity','power','power cut','outage','load shedding','transformer','bill',
    'disconnection','voltage','shortage','no electricity','current','wire','pole',
    'meter','meter reading','electricity department','supply','connection',
    'voltage fluctuation','short circuit','trip','breakdown','grid','substation'
    ] WHERE code = 'ELECTRICITY_FAILURE';

UPDATE incident_categories SET keywords = ARRAY[
    'power','electricity','power cut','outage','load shedding','transformer',
    'voltage fluctuation','short circuit','breakdown','power failure','no power',
    'grid','substation','feeder','distribution','generation','transmission','supply'
    ] WHERE code = 'POWER_FAILURE';

UPDATE incident_categories SET keywords = ARRAY[
    'exam','examination','nta','neet','jee','cuet','leak','paper leak',
    'irregularity','cheating','copy','malpractice','result','revaluation',
    'grace marks','cancellation','recalculation','rank','counselling','admission',
    'merit','cutoff','scam','fake','impersonation','centre','invigilator',
    'biometric','answer key','provisional','final','allotted','qualifying'
    ] WHERE code = 'EXAM_IRREGULARITY';

UPDATE incident_categories SET keywords = ARRAY[
    'water','supply','shortage','no water','pipeline','leakage','contamination',
    'quality','tanker','borewell','groundwater','municipal water','jal board',
    'jal shakti','water department','drinking water','water connection','meter',
    'water bill','sewage','sewer','waterborne','contaminated','dirty water',
    'water pressure','low pressure','no supply','intermittent'
    ] WHERE code = 'WATER_SUPPLY_FAILURE';

UPDATE incident_categories SET keywords = ARRAY[
    'road','pothole','damage','construction','repair','highway','national highway',
    'toll','toll tax','speed breaker','street','footpath','bridge','flyover',
    'traffic','congestion','accident','road safety','divider','asphalt','concrete',
    'morth','nhai','pwd','public works','road work','digging','trenching',
    'encroachment','crack','broken road','unmarked','no signage'
    ] WHERE code = 'ROAD_DAMAGE';

UPDATE incident_categories SET keywords = ARRAY[
    'food','safety','adulteration','contaminated','expired','fssai','restaurant',
    'hotel','dhaba','street food','food poisoning','quality','hygiene','license',
    'inspection','packaged','label','misbranding','substandard','unsafe',
    'food delivery','swiggy','zomato','canteen','mess','midday meal'
    ] WHERE code = 'FOOD_SAFETY';

UPDATE incident_categories SET keywords = ARRAY[
    'hospital','doctor','healthcare','negligence','treatment','medicine','opd',
    'emergency','icu','bed','patient','medical','health','clinic','nursing',
    'diagnostic','test','report','surgery','refund','bill','insurance',
    'ayushman','pmjay','emi','pharmacy','drug','vaccine','blood','ambulance',
    'government hospital','primary health','phc','chc','district hospital'
    ] WHERE code = 'HEALTHCARE_ISSUE';

UPDATE incident_categories SET keywords = ARRAY[
    'corruption','bribe','bribery','vigilance','graft','kickback','scam',
    'embezzlement','misappropriation','disproportionate assets','lokpal',
    'lokayukta','cvc','cbi','acb','anti corruption','whistleblower',
    'accountability','transparency','red tape','tender','procurement',
    'contract','favoritism','nepotism','cronyism','commission','cut'
    ] WHERE code = 'CORRUPTION';