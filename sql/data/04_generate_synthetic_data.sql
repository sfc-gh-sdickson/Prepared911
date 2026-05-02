------------------------------------------------------------------------
-- Prepared911 Intelligence Agent
-- File: 04_generate_synthetic_data.sql
-- Purpose: Generate realistic synthetic 911 emergency response data
------------------------------------------------------------------------

USE DATABASE PREPARED911_INTELLIGENCE;
USE SCHEMA RAW;
USE WAREHOUSE PREPARED911_WH;

------------------------------------------------------------------------
-- GEOGRAPHIC_ZONES
------------------------------------------------------------------------
INSERT INTO GEOGRAPHIC_ZONES VALUES
('ZONE-01', 'Downtown Core', 'URBAN', 'Central', 45000, 2.5, 'HIGH', 3, 300, 33.7490, -84.3880, CURRENT_TIMESTAMP()),
('ZONE-02', 'Midtown', 'URBAN', 'Central', 32000, 3.8, 'HIGH', 2, 360, 33.7840, -84.3830, CURRENT_TIMESTAMP()),
('ZONE-03', 'Westside', 'URBAN', 'West', 28000, 5.2, 'MEDIUM', 2, 420, 33.7580, -84.4320, CURRENT_TIMESTAMP()),
('ZONE-04', 'Eastside', 'URBAN', 'East', 35000, 4.1, 'MEDIUM', 2, 420, 33.7560, -84.3450, CURRENT_TIMESTAMP()),
('ZONE-05', 'Northside', 'SUBURBAN', 'North', 52000, 12.5, 'LOW', 2, 480, 33.8200, -84.3680, CURRENT_TIMESTAMP()),
('ZONE-06', 'Southside', 'URBAN', 'South', 41000, 6.8, 'HIGH', 2, 360, 33.7100, -84.3900, CURRENT_TIMESTAMP()),
('ZONE-07', 'Industrial District', 'INDUSTRIAL', 'West', 8000, 8.3, 'MEDIUM', 1, 480, 33.7400, -84.4600, CURRENT_TIMESTAMP()),
('ZONE-08', 'University District', 'URBAN', 'East', 25000, 2.1, 'MEDIUM', 1, 360, 33.7760, -84.3960, CURRENT_TIMESTAMP()),
('ZONE-09', 'Airport Corridor', 'SUBURBAN', 'South', 15000, 15.0, 'LOW', 1, 540, 33.6400, -84.4280, CURRENT_TIMESTAMP()),
('ZONE-10', 'Northwest Suburbs', 'SUBURBAN', 'North', 68000, 22.0, 'LOW', 2, 540, 33.8600, -84.4200, CURRENT_TIMESTAMP());

------------------------------------------------------------------------
-- RESPONSE_UNITS
------------------------------------------------------------------------
INSERT INTO RESPONSE_UNITS
SELECT
    'UNIT-' || LPAD(SEQ4()::VARCHAR, 3, '0'),
    CASE MOD(SEQ4(), 12)
        WHEN 0 THEN 'Engine ' || (SEQ4() / 12 + 1)::VARCHAR
        WHEN 1 THEN 'Ladder ' || (SEQ4() / 12 + 1)::VARCHAR
        WHEN 2 THEN 'Medic ' || (SEQ4() / 12 + 1)::VARCHAR
        WHEN 3 THEN 'Rescue ' || (SEQ4() / 12 + 1)::VARCHAR
        WHEN 4 THEN 'Battalion ' || (SEQ4() / 12 + 1)::VARCHAR
        WHEN 5 THEN 'Patrol ' || (SEQ4() / 12 + 1)::VARCHAR
        WHEN 6 THEN 'Engine ' || (SEQ4() / 12 + 10)::VARCHAR
        WHEN 7 THEN 'Medic ' || (SEQ4() / 12 + 10)::VARCHAR
        WHEN 8 THEN 'Patrol ' || (SEQ4() / 12 + 10)::VARCHAR
        WHEN 9 THEN 'Ladder ' || (SEQ4() / 12 + 10)::VARCHAR
        WHEN 10 THEN 'K9 ' || (SEQ4() / 12 + 1)::VARCHAR
        ELSE 'Hazmat ' || (SEQ4() / 12 + 1)::VARCHAR
    END,
    CASE MOD(SEQ4(), 12)
        WHEN 0 THEN 'ENGINE' WHEN 1 THEN 'LADDER' WHEN 2 THEN 'ALS_AMBULANCE'
        WHEN 3 THEN 'RESCUE' WHEN 4 THEN 'BATTALION_CHIEF' WHEN 5 THEN 'PATROL'
        WHEN 6 THEN 'ENGINE' WHEN 7 THEN 'BLS_AMBULANCE' WHEN 8 THEN 'PATROL'
        WHEN 9 THEN 'LADDER' WHEN 10 THEN 'K9' ELSE 'HAZMAT'
    END,
    'STN-' || LPAD((MOD(SEQ4(), 10) + 1)::VARCHAR, 2, '0'),
    'Station ' || (MOD(SEQ4(), 10) + 1)::VARCHAR,
    CASE WHEN RANDOM() > 0.15 THEN 'AVAILABLE' ELSE 'ON_CALL' END,
    CASE MOD(SEQ4(), 12)
        WHEN 4 THEN 1 WHEN 5 THEN 1 WHEN 8 THEN 1 WHEN 10 THEN 1
        ELSE UNIFORM(2, 6, RANDOM())
    END,
    NULL,
    CASE MOD(SEQ4(), 12)
        WHEN 0 THEN 'Type 1 Engine' WHEN 1 THEN 'Quint/Aerial' WHEN 2 THEN 'Type I Ambulance'
        WHEN 3 THEN 'Heavy Rescue' WHEN 4 THEN 'SUV Command' WHEN 5 THEN 'Sedan Patrol'
        WHEN 6 THEN 'Type 1 Engine' WHEN 7 THEN 'Type III Ambulance' WHEN 8 THEN 'SUV Patrol'
        WHEN 9 THEN 'Tiller Aerial' WHEN 10 THEN 'SUV K9' ELSE 'Hazmat Truck'
    END,
    'ZONE-' || LPAD((MOD(SEQ4(), 10) + 1)::VARCHAR, 2, '0'),
    DATEADD('day', -UNIFORM(1, 180, RANDOM()), CURRENT_DATE()),
    DATEADD('year', -UNIFORM(1, 15, RANDOM()), CURRENT_DATE()),
    CURRENT_TIMESTAMP()
FROM TABLE(GENERATOR(ROWCOUNT => 48));

------------------------------------------------------------------------
-- PERSONNEL
------------------------------------------------------------------------
INSERT INTO PERSONNEL
SELECT
    'PER-' || LPAD(SEQ4()::VARCHAR, 4, '0'),
    CASE MOD(SEQ4(), 20)
        WHEN 0 THEN 'James' WHEN 1 THEN 'Maria' WHEN 2 THEN 'Robert' WHEN 3 THEN 'Sarah'
        WHEN 4 THEN 'Michael' WHEN 5 THEN 'Jennifer' WHEN 6 THEN 'David' WHEN 7 THEN 'Lisa'
        WHEN 8 THEN 'Carlos' WHEN 9 THEN 'Amanda' WHEN 10 THEN 'Thomas' WHEN 11 THEN 'Jessica'
        WHEN 12 THEN 'Daniel' WHEN 13 THEN 'Ashley' WHEN 14 THEN 'William' WHEN 15 THEN 'Emily'
        WHEN 16 THEN 'Joseph' WHEN 17 THEN 'Rachel' WHEN 18 THEN 'Kevin' ELSE 'Michelle'
    END,
    CASE MOD(SEQ4(), 15)
        WHEN 0 THEN 'Johnson' WHEN 1 THEN 'Martinez' WHEN 2 THEN 'Williams' WHEN 3 THEN 'Garcia'
        WHEN 4 THEN 'Brown' WHEN 5 THEN 'Davis' WHEN 6 THEN 'Rodriguez' WHEN 7 THEN 'Wilson'
        WHEN 8 THEN 'Anderson' WHEN 9 THEN 'Thomas' WHEN 10 THEN 'Taylor' WHEN 11 THEN 'Moore'
        WHEN 12 THEN 'Jackson' WHEN 13 THEN 'Lee' ELSE 'Harris'
    END,
    CASE MOD(SEQ4(), 8)
        WHEN 0 THEN 'CALLTAKER' WHEN 1 THEN 'DISPATCHER' WHEN 2 THEN 'SUPERVISOR'
        WHEN 3 THEN 'FIREFIGHTER' WHEN 4 THEN 'PARAMEDIC' WHEN 5 THEN 'PATROL_OFFICER'
        WHEN 6 THEN 'CALLTAKER' ELSE 'QA_ANALYST'
    END,
    'B' || LPAD(UNIFORM(1000, 9999, RANDOM())::VARCHAR, 4, '0'),
    'STN-' || LPAD((MOD(SEQ4(), 10) + 1)::VARCHAR, 2, '0'),
    CASE MOD(SEQ4(), 3) WHEN 0 THEN 'A' WHEN 1 THEN 'B' ELSE 'C' END,
    NULL,
    DATEADD('year', -UNIFORM(1, 20, RANDOM()), CURRENT_DATE()),
    UNIFORM(20, 200, RANDOM())::NUMBER(6,1),
    UNIFORM(70, 100, RANDOM())::NUMBER(5,2),
    'ACTIVE',
    CURRENT_TIMESTAMP()
FROM TABLE(GENERATOR(ROWCOUNT => 120));

------------------------------------------------------------------------
-- INCIDENT_CALLS (5000 records over 12 months)
------------------------------------------------------------------------
INSERT INTO INCIDENT_CALLS
SELECT
    'CALL-' || LPAD(SEQ4()::VARCHAR, 6, '0'),
    DATEADD('minute', -UNIFORM(1, 525600, RANDOM()), CURRENT_TIMESTAMP()),
    '(' || UNIFORM(200, 999, RANDOM())::VARCHAR || ') ' || UNIFORM(100, 999, RANDOM())::VARCHAR || '-' || UNIFORM(1000, 9999, RANDOM())::VARCHAR,
    UNIFORM(100, 9999, RANDOM())::VARCHAR || ' ' ||
        CASE MOD(SEQ4(), 10)
            WHEN 0 THEN 'Main St' WHEN 1 THEN 'Oak Ave' WHEN 2 THEN 'Peachtree Rd'
            WHEN 3 THEN 'Martin Luther King Jr Dr' WHEN 4 THEN 'Spring St'
            WHEN 5 THEN 'Piedmont Ave' WHEN 6 THEN 'North Ave' WHEN 7 THEN 'Boulevard'
            WHEN 8 THEN 'Memorial Dr' ELSE 'Ponce de Leon Ave'
        END,
    33.7 + (RANDOM() * 0.2),
    -84.3 - (RANDOM() * 0.2),
    CASE MOD(SEQ4(), 22)
        WHEN 0 THEN 'MEDICAL' WHEN 1 THEN 'MEDICAL' WHEN 2 THEN 'MEDICAL'
        WHEN 3 THEN 'MEDICAL' WHEN 4 THEN 'MEDICAL' WHEN 5 THEN 'FIRE'
        WHEN 6 THEN 'FIRE' WHEN 7 THEN 'FIRE' WHEN 8 THEN 'LAW_ENFORCEMENT'
        WHEN 9 THEN 'LAW_ENFORCEMENT' WHEN 10 THEN 'LAW_ENFORCEMENT'
        WHEN 11 THEN 'MEDICAL' WHEN 12 THEN 'MEDICAL' WHEN 13 THEN 'TRAFFIC'
        WHEN 14 THEN 'TRAFFIC' WHEN 15 THEN 'FIRE_ALARM' WHEN 16 THEN 'MEDICAL'
        WHEN 17 THEN 'RESCUE' WHEN 18 THEN 'LAW_ENFORCEMENT' WHEN 19 THEN 'MEDICAL'
        WHEN 20 THEN 'HAZMAT' ELSE 'MEDICAL'
    END,
    CASE MOD(SEQ4(), 15)
        WHEN 0 THEN 'Cardiac Arrest' WHEN 1 THEN 'Breathing Problem' WHEN 2 THEN 'Fall Injury'
        WHEN 3 THEN 'Structure Fire' WHEN 4 THEN 'Traffic Accident' WHEN 5 THEN 'Assault'
        WHEN 6 THEN 'Overdose' WHEN 7 THEN 'Chest Pain' WHEN 8 THEN 'Burglary'
        WHEN 9 THEN 'Vehicle Fire' WHEN 10 THEN 'Stroke' WHEN 11 THEN 'Domestic'
        WHEN 12 THEN 'Fire Alarm' WHEN 13 THEN 'Sick Person' ELSE 'Unconscious'
    END,
    UNIFORM(1, 5, RANDOM()),
    CASE WHEN RANDOM() > 0.88 THEN
        CASE MOD(SEQ4(), 8)
            WHEN 0 THEN 'Spanish' WHEN 1 THEN 'Mandarin' WHEN 2 THEN 'Vietnamese'
            WHEN 3 THEN 'Korean' WHEN 4 THEN 'Arabic' WHEN 5 THEN 'French'
            WHEN 6 THEN 'Portuguese' ELSE 'Haitian Creole'
        END
    ELSE 'English' END,
    CASE WHEN RANDOM() > 0.88 THEN TRUE ELSE FALSE END,
    UNIFORM(30, 900, RANDOM()),
    UNIFORM(45, 600, RANDOM()),
    CASE MOD(SEQ4(), 5)
        WHEN 0 THEN 'DISPATCHED' WHEN 1 THEN 'DISPATCHED' WHEN 2 THEN 'DISPATCHED'
        WHEN 3 THEN 'INFORMATION_ONLY' ELSE 'TRANSFERRED'
    END,
    CASE WHEN RANDOM() > 0.5 THEN '911' ELSE
        CASE MOD(SEQ4(), 4)
            WHEN 0 THEN 'NON_EMERGENCY' WHEN 1 THEN 'TEXT_911' WHEN 2 THEN 'TRANSFER' ELSE '911'
        END
    END,
    'ZONE-' || LPAD((MOD(SEQ4(), 10) + 1)::VARCHAR, 2, '0'),
    'PER-' || LPAD((MOD(SEQ4(), 30))::VARCHAR, 4, '0'),
    CURRENT_TIMESTAMP()
FROM TABLE(GENERATOR(ROWCOUNT => 5000));

------------------------------------------------------------------------
-- INCIDENTS
------------------------------------------------------------------------
INSERT INTO INCIDENTS
SELECT
    'INC-' || LPAD(SEQ4()::VARCHAR, 6, '0'),
    'CALL-' || LPAD(SEQ4()::VARCHAR, 6, '0'),
    CASE MOD(SEQ4(), 22)
        WHEN 0 THEN 'MED-CARDIAC' WHEN 1 THEN 'MED-RESP' WHEN 2 THEN 'MED-TRAUMA'
        WHEN 3 THEN 'MED-FALL' WHEN 4 THEN 'MED-SICK' WHEN 5 THEN 'FIRE-STRUCT'
        WHEN 6 THEN 'FIRE-VEH' WHEN 7 THEN 'FIRE-ALARM' WHEN 8 THEN 'LAW-VIOLENT'
        WHEN 9 THEN 'LAW-PROPERTY' WHEN 10 THEN 'LAW-TRAFFIC'
        WHEN 11 THEN 'MED-STROKE' WHEN 12 THEN 'MED-OD' WHEN 13 THEN 'LAW-TRAFFIC'
        WHEN 14 THEN 'LAW-DOMESTIC' WHEN 15 THEN 'FIRE-ALARM' WHEN 16 THEN 'MED-CARDIAC'
        WHEN 17 THEN 'RESCUE-WATER' WHEN 18 THEN 'LAW-PROPERTY' WHEN 19 THEN 'MED-RESP'
        WHEN 20 THEN 'FIRE-HAZ' ELSE 'MED-SICK'
    END,
    CASE MOD(SEQ4(), 22)
        WHEN 0 THEN 'Cardiac Arrest' WHEN 1 THEN 'Breathing Problem' WHEN 2 THEN 'Traumatic Injury'
        WHEN 3 THEN 'Fall Injury' WHEN 4 THEN 'Sick Person' WHEN 5 THEN 'Structure Fire'
        WHEN 6 THEN 'Vehicle Fire' WHEN 7 THEN 'Fire Alarm' WHEN 8 THEN 'Assault/Battery'
        WHEN 9 THEN 'Burglary/Theft' WHEN 10 THEN 'Traffic Accident'
        WHEN 11 THEN 'Stroke/CVA' WHEN 12 THEN 'Overdose' WHEN 13 THEN 'Traffic Accident'
        WHEN 14 THEN 'Domestic Disturbance' WHEN 15 THEN 'Fire Alarm' WHEN 16 THEN 'Cardiac Arrest'
        WHEN 17 THEN 'Water Rescue' WHEN 18 THEN 'Theft Report' WHEN 19 THEN 'Difficulty Breathing'
        WHEN 20 THEN 'Hazmat Spill' ELSE 'General Illness'
    END,
    CASE UNIFORM(1, 5, RANDOM())
        WHEN 1 THEN 'CRITICAL' WHEN 2 THEN 'MAJOR' WHEN 3 THEN 'MODERATE'
        WHEN 4 THEN 'MINOR' ELSE 'ROUTINE'
    END,
    CASE MOD(SEQ4(), 10)
        WHEN 0 THEN 'CLOSED' WHEN 1 THEN 'CLOSED' WHEN 2 THEN 'CLOSED'
        WHEN 3 THEN 'CLOSED' WHEN 4 THEN 'CLOSED' WHEN 5 THEN 'CLOSED'
        WHEN 6 THEN 'CLOSED' WHEN 7 THEN 'CLOSED' WHEN 8 THEN 'ACTIVE' ELSE 'IN_PROGRESS'
    END,
    UNIFORM(100, 9999, RANDOM())::VARCHAR || ' ' ||
        CASE MOD(SEQ4(), 10)
            WHEN 0 THEN 'Main St' WHEN 1 THEN 'Oak Ave' WHEN 2 THEN 'Peachtree Rd'
            WHEN 3 THEN 'MLK Jr Dr' WHEN 4 THEN 'Spring St' WHEN 5 THEN 'Piedmont Ave'
            WHEN 6 THEN 'North Ave' WHEN 7 THEN 'Boulevard' WHEN 8 THEN 'Memorial Dr'
            ELSE 'Ponce de Leon Ave'
        END,
    33.7 + (RANDOM() * 0.2),
    -84.3 - (RANDOM() * 0.2),
    'ZONE-' || LPAD((MOD(SEQ4(), 10) + 1)::VARCHAR, 2, '0'),
    CASE MOD(SEQ4(), 5)
        WHEN 0 THEN 'Patient found unresponsive on floor. Bystander CPR in progress.'
        WHEN 1 THEN 'Caller reports smoke visible from second floor window. Occupants evacuating.'
        WHEN 2 THEN 'Two vehicle collision at intersection. One patient with head injury.'
        WHEN 3 THEN 'Domestic dispute escalating. Sounds of breaking glass reported by neighbor.'
        ELSE 'Caller states elderly patient fell and cannot get up. Conscious and breathing.'
    END,
    DATEADD('minute', -UNIFORM(1, 525600, RANDOM()), CURRENT_TIMESTAMP()),
    NULL, NULL, NULL,
    UNIFORM(1, 6, RANDOM()),
    CASE WHEN MOD(SEQ4(), 3) < 2 THEN UNIFORM(0, 3, RANDOM()) ELSE 0 END,
    CURRENT_TIMESTAMP()
FROM TABLE(GENERATOR(ROWCOUNT => 4000));

UPDATE INCIDENTS SET
    FIRST_UNIT_ENROUTE = DATEADD('second', UNIFORM(60, 180, RANDOM()), DISPATCH_TIMESTAMP),
    FIRST_UNIT_ONSCENE = DATEADD('second', UNIFORM(180, 600, RANDOM()), DISPATCH_TIMESTAMP),
    INCIDENT_CLOSED = DATEADD('minute', UNIFORM(15, 180, RANDOM()), DISPATCH_TIMESTAMP)
WHERE STATUS = 'CLOSED';

------------------------------------------------------------------------
-- UNIT_DISPATCHES
------------------------------------------------------------------------
INSERT INTO UNIT_DISPATCHES
SELECT
    'DISP-' || LPAD(SEQ4()::VARCHAR, 6, '0'),
    'INC-' || LPAD((MOD(SEQ4(), 4000))::VARCHAR, 6, '0'),
    'UNIT-' || LPAD((MOD(SEQ4(), 48))::VARCHAR, 3, '0'),
    DATEADD('minute', -UNIFORM(1, 525600, RANDOM()), CURRENT_TIMESTAMP()),
    NULL, NULL, NULL, NULL, NULL,
    UNIFORM(120, 900, RANDOM()),
    UNIFORM(60, 600, RANDOM()),
    UNIFORM(300, 7200, RANDOM()),
    UNIFORM(600, 10800, RANDOM()),
    UNIFORM(1, 15, RANDOM())::NUMBER(6,2),
    CASE MOD(SEQ4(), 5)
        WHEN 0 THEN 'PATIENT_TRANSPORTED' WHEN 1 THEN 'SCENE_CLEARED' WHEN 2 THEN 'PATIENT_REFUSED'
        WHEN 3 THEN 'FIRE_EXTINGUISHED' ELSE 'REPORT_TAKEN'
    END,
    CURRENT_TIMESTAMP()
FROM TABLE(GENERATOR(ROWCOUNT => 8000));

UPDATE UNIT_DISPATCHES SET
    ENROUTE_TIMESTAMP = DATEADD('second', UNIFORM(30, 120, RANDOM()), DISPATCH_TIMESTAMP),
    ONSCENE_TIMESTAMP = DATEADD('second', RESPONSE_TIME_SEC, DISPATCH_TIMESTAMP),
    CLEAR_TIMESTAMP = DATEADD('second', TOTAL_TIME_SEC, DISPATCH_TIMESTAMP);

------------------------------------------------------------------------
-- CALL_TRANSLATIONS
------------------------------------------------------------------------
INSERT INTO CALL_TRANSLATIONS
SELECT
    'TRANS-' || LPAD(SEQ4()::VARCHAR, 5, '0'),
    c.CALL_ID,
    c.LANGUAGE_PRIMARY,
    'English',
    CASE MOD(SEQ4(), 3) WHEN 0 THEN 'AUDIO_AI' WHEN 1 THEN 'TEXT_AI' ELSE 'TEXT_TO_VOICE' END,
    CASE WHEN MOD(SEQ4(), 3) = 0 THEN TRUE ELSE FALSE END,
    CASE WHEN MOD(SEQ4(), 3) != 0 THEN TRUE ELSE FALSE END,
    UNIFORM(30, 600, RANDOM()),
    UNIFORM(85, 99, RANDOM())::NUMBER(5,2),
    UNIFORM(50, 500, RANDOM()),
    CURRENT_TIMESTAMP()
FROM INCIDENT_CALLS c
WHERE c.TRANSLATION_NEEDED = TRUE
LIMIT 600;

------------------------------------------------------------------------
-- QA_EVALUATIONS
------------------------------------------------------------------------
INSERT INTO QA_EVALUATIONS
SELECT
    'QA-' || LPAD(SEQ4()::VARCHAR, 6, '0'),
    'CALL-' || LPAD((MOD(SEQ4(), 5000))::VARCHAR, 6, '0'),
    'PER-' || LPAD((MOD(SEQ4(), 5) + 115)::VARCHAR, 4, '0'),
    DATEADD('day', -UNIFORM(1, 365, RANDOM()), CURRENT_DATE()),
    UNIFORM(60, 100, RANDOM())::NUMBER(5,2),
    UNIFORM(60, 100, RANDOM())::NUMBER(5,2),
    UNIFORM(55, 100, RANDOM())::NUMBER(5,2),
    UNIFORM(65, 100, RANDOM())::NUMBER(5,2),
    UNIFORM(60, 100, RANDOM())::NUMBER(5,2),
    UNIFORM(70, 100, RANDOM())::NUMBER(5,2),
    CASE WHEN RANDOM() > 0.3 THEN TRUE ELSE FALSE END,
    CASE MOD(SEQ4(), 5)
        WHEN 0 THEN 'Excellent call handling. All protocols followed.'
        WHEN 1 THEN 'Good information gathering but could improve closing.'
        WHEN 2 THEN 'Protocol adherence needs improvement on medical calls.'
        WHEN 3 THEN 'Strong communication skills demonstrated throughout.'
        ELSE 'Minor gaps in address verification process.'
    END,
    NULL,
    CURRENT_TIMESTAMP()
FROM TABLE(GENERATOR(ROWCOUNT => 3000));

------------------------------------------------------------------------
-- PROTOCOLS
------------------------------------------------------------------------
INSERT INTO PROTOCOLS VALUES
('PROTO-001', 'Cardiac Arrest Response Protocol', 'MEDICAL', 'Cardiac', 'Standardized response protocol for cardiac arrest calls including pre-arrival CPR instructions and ALS dispatch requirements', '1. Verify cardiac arrest (unresponsive, not breathing normally)\n2. Instruct caller to begin chest compressions\n3. Dispatch ALS unit Priority 1\n4. Dispatch Engine company for first response\n5. Provide continuous CPR coaching until unit arrival\n6. Relay patient age and circumstances to responding units', 1, '2024-01-01', '2024-06-15', 'ACTIVE', ARRAY_CONSTRUCT('MED-CARDIAC'), 'MPDS Protocol 9', CURRENT_TIMESTAMP()),
('PROTO-002', 'Structure Fire Initial Response', 'FIRE', 'Suppression', 'Full first alarm assignment for confirmed structure fires including resource deployment and incident command establishment', '1. Dispatch full first alarm assignment (2 engines, 1 ladder, 1 rescue, 1 battalion chief)\n2. Confirm address and cross streets\n3. Determine occupancy type and occupants status\n4. Instruct caller to evacuate if not already done\n5. Establish incident command on first unit arrival\n6. Begin 360 size-up before committing to interior operations', 1, '2024-01-01', '2024-08-01', 'ACTIVE', ARRAY_CONSTRUCT('FIRE-STRUCT'), 'NFPA 1710', CURRENT_TIMESTAMP()),
('PROTO-003', 'Domestic Violence Response', 'LAW_ENFORCEMENT', 'Domestic', 'Response protocol for domestic violence calls with safety considerations for responders and victims', '1. Dispatch minimum 2 patrol units\n2. Check address history for prior incidents\n3. Determine if weapons present\n4. Stage if active violence with weapons reported\n5. One unit makes contact, second covers\n6. Separate parties immediately upon arrival\n7. Document injuries with photos\n8. Provide victim with DV resources', 1, '2024-01-01', '2024-03-20', 'ACTIVE', ARRAY_CONSTRUCT('LAW-DOMESTIC', 'LAW-VIOLENT'), 'State DV Protocol', CURRENT_TIMESTAMP()),
('PROTO-004', 'Multi-Language Call Handling', 'OPERATIONS', 'Communication', 'Procedure for handling 911 calls from non-English speaking callers using AI translation services', '1. Identify language (system auto-detects from audio)\n2. Activate real-time audio translation\n3. Use simplified questions for critical information\n4. Confirm address using text-based translation for accuracy\n5. Dispatch appropriate resources based on translated information\n6. Note language in CAD for responding units\n7. Log translation accuracy for QA review', 2, '2024-03-01', '2025-01-10', 'ACTIVE', NULL, 'NENA i3 Language Services', CURRENT_TIMESTAMP()),
('PROTO-005', 'Stroke Recognition and Response', 'MEDICAL', 'Neurological', 'Time-critical protocol for suspected stroke including FAST assessment and stroke center notification', '1. Assess using FAST criteria (Face, Arms, Speech, Time)\n2. Document time of symptom onset\n3. Dispatch ALS unit Priority 1\n4. Pre-notify stroke center if symptoms < 4.5 hours\n5. Instruct caller to not give food/water\n6. Keep patient still and comfortable\n7. Note last known well time for responding units', 1, '2024-01-01', '2024-09-01', 'ACTIVE', ARRAY_CONSTRUCT('MED-STROKE'), 'MPDS Protocol 28', CURRENT_TIMESTAMP()),
('PROTO-006', 'Hazardous Materials Initial Response', 'FIRE', 'Hazmat', 'Initial response protocol for hazmat incidents including isolation, identification, and notification procedures', '1. Gather information: substance, quantity, container type\n2. Dispatch Hazmat unit and engine company\n3. Establish initial isolation zone (minimum 330 ft)\n4. Direct evacuation if populated area\n5. Reference ERG for substance-specific guidance\n6. Notify environmental agency if required\n7. Stage EMS upwind from incident', 1, '2024-01-01', '2024-07-15', 'ACTIVE', ARRAY_CONSTRUCT('FIRE-HAZ'), 'NFPA 472 / ERG 2024', CURRENT_TIMESTAMP()),
('PROTO-007', 'Quality Assurance Evaluation Standards', 'QA', 'Evaluation', 'Standards and criteria for evaluating 911 call-taker performance across all call types', '1. Greeting within 10 seconds of connection\n2. Address verification (street, city, apartment)\n3. Chief complaint identification within 30 seconds\n4. Appropriate priority assignment\n5. Pre-arrival instructions delivered when applicable\n6. Caller management throughout call\n7. Proper CAD documentation\n8. Professional closing with callback number confirmation', 3, '2024-01-01', '2025-02-01', 'ACTIVE', NULL, 'APCO P33 / NENA Standards', CURRENT_TIMESTAMP()),
('PROTO-008', 'Active Shooter Response', 'LAW_ENFORCEMENT', 'Critical Incident', 'Protocol for responding to active shooter or active threat situations', '1. Dispatch all available units Priority 1\n2. Determine location within structure\n3. Confirm active shooting vs. shots fired\n4. Stage EMS in warm zone\n5. Form contact team (minimum 4 officers)\n6. Immediately engage threat\n7. Begin rescue task force operations once threat neutralized\n8. Establish unified command', 1, '2024-01-01', '2024-11-01', 'ACTIVE', ARRAY_CONSTRUCT('LAW-VIOLENT'), 'DHS Active Shooter Protocol', CURRENT_TIMESTAMP()),
('PROTO-009', 'Overdose Response with Narcan', 'MEDICAL', 'Toxicology', 'Protocol for suspected opioid overdose including Narcan administration instructions', '1. Assess responsiveness and breathing\n2. If unresponsive with slow/no breathing, suspect opioid OD\n3. Dispatch ALS unit Priority 1\n4. Instruct caller on Narcan administration if available\n5. Begin rescue breathing if trained\n6. Place in recovery position after Narcan\n7. Warn caller patient may become combative\n8. Stay on line until units arrive', 1, '2024-06-01', '2025-01-15', 'ACTIVE', ARRAY_CONSTRUCT('MED-OD'), 'MPDS Protocol 23', CURRENT_TIMESTAMP()),
('PROTO-010', 'Non-Emergency Call Triage', 'OPERATIONS', 'Triage', 'Protocol for handling non-emergency calls and routing to appropriate services', '1. Identify call as non-emergency through triage questions\n2. Determine if any life safety component exists\n3. If life safety, upgrade to emergency processing\n4. Otherwise, route to appropriate non-emergency service\n5. Provide caller with non-emergency number for future\n6. Document call in non-emergency queue\n7. If high volume period, offer callback option', 4, '2024-01-01', '2025-03-01', 'ACTIVE', NULL, 'NENA Non-Emergency Standards', CURRENT_TIMESTAMP());
