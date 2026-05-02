------------------------------------------------------------------------
-- Prepared911 Intelligence Agent
-- File: 03_Emergency_Response_Ontology.sql
-- Purpose: Create NIEM/NIMS-based Emergency Response Ontology
------------------------------------------------------------------------

USE DATABASE PREPARED911_INTELLIGENCE;
USE SCHEMA ONTOLOGY;
USE WAREHOUSE PREPARED911_WH;

------------------------------------------------------------------------
-- ONTOLOGY_CLASSES: Domain concept classes
------------------------------------------------------------------------
CREATE OR REPLACE TABLE ONTOLOGY_CLASSES (
    CLASS_ID            VARCHAR(50) PRIMARY KEY,
    CLASS_NAME          VARCHAR(100) NOT NULL,
    PARENT_CLASS_ID     VARCHAR(50),
    DOMAIN              VARCHAR(50) NOT NULL,
    DESCRIPTION         VARCHAR(500),
    STANDARD_REF        VARCHAR(100),
    LEVEL               NUMBER(3),
    CREATED_AT          TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP()
);

INSERT INTO ONTOLOGY_CLASSES VALUES
('ROOT', 'EmergencyResponse', NULL, 'CORE', 'Root class for all emergency response concepts', 'NIEM-5.0', 0, CURRENT_TIMESTAMP()),
('INC', 'Incident', 'ROOT', 'CORE', 'Any event requiring emergency response', 'NIEM-5.0', 1, CURRENT_TIMESTAMP()),
('INC_MED', 'MedicalEmergency', 'INC', 'MEDICAL', 'Medical emergencies requiring EMS response', 'MPDS-v13', 2, CURRENT_TIMESTAMP()),
('INC_MED_CARDIAC', 'CardiacEmergency', 'INC_MED', 'MEDICAL', 'Cardiac arrest or heart-related emergencies', 'MPDS-9', 3, CURRENT_TIMESTAMP()),
('INC_MED_TRAUMA', 'TraumaEmergency', 'INC_MED', 'MEDICAL', 'Traumatic injuries requiring immediate care', 'MPDS-30', 3, CURRENT_TIMESTAMP()),
('INC_MED_RESP', 'RespiratoryEmergency', 'INC_MED', 'MEDICAL', 'Breathing difficulties and respiratory distress', 'MPDS-6', 3, CURRENT_TIMESTAMP()),
('INC_MED_STROKE', 'StrokeEmergency', 'INC_MED', 'MEDICAL', 'Cerebrovascular accidents and stroke symptoms', 'MPDS-28', 3, CURRENT_TIMESTAMP()),
('INC_MED_OD', 'OverdoseEmergency', 'INC_MED', 'MEDICAL', 'Drug or substance overdose events', 'MPDS-23', 3, CURRENT_TIMESTAMP()),
('INC_FIRE', 'FireEmergency', 'INC', 'FIRE', 'Fire-related emergencies', 'NFPA-1710', 2, CURRENT_TIMESTAMP()),
('INC_FIRE_STRUCT', 'StructureFire', 'INC_FIRE', 'FIRE', 'Fire in residential or commercial structure', 'NFPA-1710', 3, CURRENT_TIMESTAMP()),
('INC_FIRE_WILD', 'WildfireIncident', 'INC_FIRE', 'FIRE', 'Wildland or brush fire events', 'NFPA-1710', 3, CURRENT_TIMESTAMP()),
('INC_FIRE_VEH', 'VehicleFire', 'INC_FIRE', 'FIRE', 'Motor vehicle fire', 'NFPA-1710', 3, CURRENT_TIMESTAMP()),
('INC_FIRE_HAZ', 'HazmatIncident', 'INC_FIRE', 'FIRE', 'Hazardous materials incidents', 'NFPA-472', 3, CURRENT_TIMESTAMP()),
('INC_LAW', 'LawEnforcementIncident', 'INC', 'LAW', 'Incidents requiring police response', 'NIBRS', 2, CURRENT_TIMESTAMP()),
('INC_LAW_VIOLENT', 'ViolentCrime', 'INC_LAW', 'LAW', 'Crimes involving violence or threat of violence', 'NIBRS', 3, CURRENT_TIMESTAMP()),
('INC_LAW_PROPERTY', 'PropertyCrime', 'INC_LAW', 'LAW', 'Crimes involving property theft or damage', 'NIBRS', 3, CURRENT_TIMESTAMP()),
('INC_LAW_TRAFFIC', 'TrafficIncident', 'INC_LAW', 'LAW', 'Motor vehicle accidents and traffic violations', 'MMUCC', 3, CURRENT_TIMESTAMP()),
('INC_LAW_DOMESTIC', 'DomesticIncident', 'INC_LAW', 'LAW', 'Domestic disturbances and violence', 'NIBRS', 3, CURRENT_TIMESTAMP()),
('INC_RESCUE', 'RescueOperation', 'INC', 'RESCUE', 'Search and rescue operations', 'NIMS', 2, CURRENT_TIMESTAMP()),
('INC_RESCUE_WATER', 'WaterRescue', 'INC_RESCUE', 'RESCUE', 'Water-related rescue operations', 'NFPA-1670', 3, CURRENT_TIMESTAMP()),
('INC_RESCUE_TECH', 'TechnicalRescue', 'INC_RESCUE', 'RESCUE', 'Confined space, collapse, or high-angle rescue', 'NFPA-1670', 3, CURRENT_TIMESTAMP()),
('RES', 'Resource', 'ROOT', 'CORE', 'Any asset deployable to an incident', 'NIMS-RT', 1, CURRENT_TIMESTAMP()),
('RES_EMS', 'EMSUnit', 'RES', 'MEDICAL', 'Emergency Medical Services unit', 'NIMS-RT', 2, CURRENT_TIMESTAMP()),
('RES_EMS_ALS', 'ALSUnit', 'RES_EMS', 'MEDICAL', 'Advanced Life Support ambulance', 'NIMS-RT', 3, CURRENT_TIMESTAMP()),
('RES_EMS_BLS', 'BLSUnit', 'RES_EMS', 'MEDICAL', 'Basic Life Support ambulance', 'NIMS-RT', 3, CURRENT_TIMESTAMP()),
('RES_FIRE', 'FireUnit', 'RES', 'FIRE', 'Fire suppression or rescue apparatus', 'NIMS-RT', 2, CURRENT_TIMESTAMP()),
('RES_FIRE_ENGINE', 'EngineCompany', 'RES_FIRE', 'FIRE', 'Pumper/engine apparatus', 'NIMS-RT', 3, CURRENT_TIMESTAMP()),
('RES_FIRE_LADDER', 'LadderCompany', 'RES_FIRE', 'FIRE', 'Aerial/ladder apparatus', 'NIMS-RT', 3, CURRENT_TIMESTAMP()),
('RES_FIRE_RESCUE', 'RescueSquad', 'RES_FIRE', 'FIRE', 'Heavy rescue apparatus', 'NIMS-RT', 3, CURRENT_TIMESTAMP()),
('RES_LAW', 'LawEnforcementUnit', 'RES', 'LAW', 'Police or sheriff unit', 'NIMS-RT', 2, CURRENT_TIMESTAMP()),
('RES_LAW_PATROL', 'PatrolUnit', 'RES_LAW', 'LAW', 'Standard patrol vehicle', 'NIMS-RT', 3, CURRENT_TIMESTAMP()),
('RES_LAW_DET', 'DetectiveUnit', 'RES_LAW', 'LAW', 'Investigative unit', 'NIMS-RT', 3, CURRENT_TIMESTAMP()),
('PROTO', 'Protocol', 'ROOT', 'CORE', 'Standard operating procedure or protocol', 'NENA-i3', 1, CURRENT_TIMESTAMP()),
('PROTO_DISPATCH', 'DispatchProtocol', 'PROTO', 'OPERATIONS', 'Call-taking and dispatch procedures', 'NENA-i3', 2, CURRENT_TIMESTAMP()),
('PROTO_MEDICAL', 'MedicalProtocol', 'PROTO', 'MEDICAL', 'Pre-arrival medical instructions', 'MPDS', 2, CURRENT_TIMESTAMP()),
('PROTO_FIRE', 'FireProtocol', 'PROTO', 'FIRE', 'Fire response and suppression procedures', 'NFPA', 2, CURRENT_TIMESTAMP()),
('GEO', 'GeographicEntity', 'ROOT', 'CORE', 'Geographic boundary or location type', 'NIEM-5.0', 1, CURRENT_TIMESTAMP()),
('GEO_ZONE', 'ResponseZone', 'GEO', 'OPERATIONS', 'Defined geographic response area', 'NENA-i3', 2, CURRENT_TIMESTAMP()),
('GEO_STATION', 'Station', 'GEO', 'OPERATIONS', 'Fire/EMS/Police station location', 'NIMS', 2, CURRENT_TIMESTAMP()),
('METRIC', 'PerformanceMetric', 'ROOT', 'CORE', 'Measurable performance indicator', 'NFPA-1710', 1, CURRENT_TIMESTAMP()),
('METRIC_RESPONSE', 'ResponseTimeMetric', 'METRIC', 'OPERATIONS', 'Time-based response performance measures', 'NFPA-1710', 2, CURRENT_TIMESTAMP()),
('METRIC_QUALITY', 'QualityMetric', 'METRIC', 'OPERATIONS', 'Service quality and compliance measures', 'NENA-i3', 2, CURRENT_TIMESTAMP());

------------------------------------------------------------------------
-- ONTOLOGY_PROPERTIES: Class attributes
------------------------------------------------------------------------
CREATE OR REPLACE TABLE ONTOLOGY_PROPERTIES (
    PROPERTY_ID         VARCHAR(50) PRIMARY KEY,
    CLASS_ID            VARCHAR(50) REFERENCES ONTOLOGY_CLASSES(CLASS_ID),
    PROPERTY_NAME       VARCHAR(100) NOT NULL,
    DATA_TYPE           VARCHAR(30),
    DESCRIPTION         VARCHAR(300),
    REQUIRED            BOOLEAN DEFAULT FALSE,
    CREATED_AT          TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP()
);

INSERT INTO ONTOLOGY_PROPERTIES VALUES
('P_INC_TYPE', 'INC', 'incidentTypeCode', 'VARCHAR', 'Standardized incident type classification code', TRUE, CURRENT_TIMESTAMP()),
('P_INC_SEV', 'INC', 'severity', 'VARCHAR', 'Incident severity level (Critical/Major/Minor)', TRUE, CURRENT_TIMESTAMP()),
('P_INC_LOC', 'INC', 'location', 'GEOGRAPHY', 'Geographic location of incident', TRUE, CURRENT_TIMESTAMP()),
('P_INC_TIME', 'INC', 'incidentTimestamp', 'TIMESTAMP', 'Date and time incident was reported', TRUE, CURRENT_TIMESTAMP()),
('P_MED_MPDS', 'INC_MED', 'mpdsCode', 'VARCHAR', 'Medical Priority Dispatch System code', TRUE, CURRENT_TIMESTAMP()),
('P_MED_CHIEF', 'INC_MED', 'chiefComplaint', 'VARCHAR', 'Primary medical complaint', TRUE, CURRENT_TIMESTAMP()),
('P_MED_PAT', 'INC_MED', 'patientCount', 'NUMBER', 'Number of patients involved', FALSE, CURRENT_TIMESTAMP()),
('P_FIRE_ALARM', 'INC_FIRE', 'alarmLevel', 'NUMBER', 'Fire alarm level (1-5)', TRUE, CURRENT_TIMESTAMP()),
('P_FIRE_STRUCT', 'INC_FIRE_STRUCT', 'structureType', 'VARCHAR', 'Type of structure (residential/commercial/industrial)', TRUE, CURRENT_TIMESTAMP()),
('P_RES_STATUS', 'RES', 'unitStatus', 'VARCHAR', 'Current operational status of resource', TRUE, CURRENT_TIMESTAMP()),
('P_RES_CAP', 'RES', 'capabilities', 'ARRAY', 'List of unit capabilities and certifications', FALSE, CURRENT_TIMESTAMP()),
('P_RES_STAFF', 'RES', 'personnelCount', 'NUMBER', 'Number of personnel assigned to unit', FALSE, CURRENT_TIMESTAMP()),
('P_METRIC_TARGET', 'METRIC_RESPONSE', 'targetSeconds', 'NUMBER', 'Target response time in seconds per NFPA standards', TRUE, CURRENT_TIMESTAMP()),
('P_METRIC_ACTUAL', 'METRIC_RESPONSE', 'actualSeconds', 'NUMBER', 'Actual measured response time', TRUE, CURRENT_TIMESTAMP()),
('P_GEO_POP', 'GEO_ZONE', 'population', 'NUMBER', 'Zone population count', FALSE, CURRENT_TIMESTAMP()),
('P_GEO_RISK', 'GEO_ZONE', 'riskLevel', 'VARCHAR', 'Zone risk classification (High/Medium/Low)', FALSE, CURRENT_TIMESTAMP());

------------------------------------------------------------------------
-- ONTOLOGY_RELATIONSHIPS: Class-to-class relationships
------------------------------------------------------------------------
CREATE OR REPLACE TABLE ONTOLOGY_RELATIONSHIPS (
    RELATIONSHIP_ID     VARCHAR(50) PRIMARY KEY,
    SOURCE_CLASS_ID     VARCHAR(50) REFERENCES ONTOLOGY_CLASSES(CLASS_ID),
    TARGET_CLASS_ID     VARCHAR(50) REFERENCES ONTOLOGY_CLASSES(CLASS_ID),
    RELATIONSHIP_TYPE   VARCHAR(50) NOT NULL,
    DESCRIPTION         VARCHAR(300),
    CARDINALITY         VARCHAR(20) DEFAULT 'MANY_TO_MANY',
    CREATED_AT          TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP()
);

INSERT INTO ONTOLOGY_RELATIONSHIPS VALUES
('R_INC_RES', 'INC', 'RES', 'requiresResource', 'An incident requires one or more resources for response', 'ONE_TO_MANY', CURRENT_TIMESTAMP()),
('R_INC_PROTO', 'INC', 'PROTO', 'hasProtocol', 'An incident type has associated response protocols', 'MANY_TO_MANY', CURRENT_TIMESTAMP()),
('R_INC_GEO', 'INC', 'GEO', 'occursIn', 'An incident occurs within a geographic zone', 'MANY_TO_ONE', CURRENT_TIMESTAMP()),
('R_INC_METRIC', 'INC', 'METRIC', 'measuredBy', 'Incident performance measured by metrics', 'ONE_TO_MANY', CURRENT_TIMESTAMP()),
('R_RES_GEO', 'RES', 'GEO_STATION', 'stationedAt', 'A resource is stationed at a location', 'MANY_TO_ONE', CURRENT_TIMESTAMP()),
('R_RES_GEO_COVERS', 'RES', 'GEO_ZONE', 'coversZone', 'A resource covers a response zone', 'MANY_TO_MANY', CURRENT_TIMESTAMP()),
('R_PROTO_INC_MED', 'PROTO_MEDICAL', 'INC_MED', 'appliesTo', 'Medical protocol applies to medical incidents', 'MANY_TO_MANY', CURRENT_TIMESTAMP()),
('R_PROTO_INC_FIRE', 'PROTO_FIRE', 'INC_FIRE', 'appliesTo', 'Fire protocol applies to fire incidents', 'MANY_TO_MANY', CURRENT_TIMESTAMP()),
('R_MED_CARDIAC_ALS', 'INC_MED_CARDIAC', 'RES_EMS_ALS', 'requiresResource', 'Cardiac emergencies require ALS units', 'ONE_TO_MANY', CURRENT_TIMESTAMP()),
('R_FIRE_STRUCT_ENG', 'INC_FIRE_STRUCT', 'RES_FIRE_ENGINE', 'requiresResource', 'Structure fires require engine companies', 'ONE_TO_MANY', CURRENT_TIMESTAMP()),
('R_FIRE_STRUCT_LAD', 'INC_FIRE_STRUCT', 'RES_FIRE_LADDER', 'requiresResource', 'Structure fires require ladder companies', 'ONE_TO_MANY', CURRENT_TIMESTAMP()),
('R_METRIC_NFPA', 'METRIC_RESPONSE', 'PROTO', 'definedBy', 'Response metrics defined by NFPA standards', 'MANY_TO_ONE', CURRENT_TIMESTAMP()),
('R_LAW_PATROL', 'INC_LAW', 'RES_LAW_PATROL', 'requiresResource', 'Law enforcement incidents require patrol units', 'ONE_TO_MANY', CURRENT_TIMESTAMP());

------------------------------------------------------------------------
-- INCIDENT_TYPE_HIERARCHY: MPDS/dispatch codes mapped to ontology
------------------------------------------------------------------------
CREATE OR REPLACE TABLE INCIDENT_TYPE_HIERARCHY (
    TYPE_CODE           VARCHAR(20) PRIMARY KEY,
    TYPE_NAME           VARCHAR(100) NOT NULL,
    CLASS_ID            VARCHAR(50) REFERENCES ONTOLOGY_CLASSES(CLASS_ID),
    PARENT_TYPE_CODE    VARCHAR(20),
    PRIORITY_DEFAULT    NUMBER(1),
    RESPONSE_PROFILE    VARCHAR(50),
    DESCRIPTION         VARCHAR(300),
    NFPA_TARGET_SEC     NUMBER(6),
    CREATED_AT          TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP()
);

INSERT INTO INCIDENT_TYPE_HIERARCHY VALUES
('MED', 'Medical Emergency', 'INC_MED', NULL, 2, 'EMS_STANDARD', 'General medical emergency', 480, CURRENT_TIMESTAMP()),
('MED-CARDIAC', 'Cardiac Arrest/AED', 'INC_MED_CARDIAC', 'MED', 1, 'EMS_CRITICAL', 'Cardiac arrest - immediate CPR/AED needed', 360, CURRENT_TIMESTAMP()),
('MED-TRAUMA', 'Traumatic Injury', 'INC_MED_TRAUMA', 'MED', 1, 'EMS_CRITICAL', 'Severe traumatic injury', 360, CURRENT_TIMESTAMP()),
('MED-RESP', 'Breathing Problems', 'INC_MED_RESP', 'MED', 2, 'EMS_URGENT', 'Respiratory distress or difficulty breathing', 480, CURRENT_TIMESTAMP()),
('MED-STROKE', 'Stroke/CVA', 'INC_MED_STROKE', 'MED', 1, 'EMS_CRITICAL', 'Suspected stroke - time critical', 360, CURRENT_TIMESTAMP()),
('MED-OD', 'Overdose/Poisoning', 'INC_MED_OD', 'MED', 1, 'EMS_CRITICAL', 'Drug overdose or poisoning', 360, CURRENT_TIMESTAMP()),
('MED-FALL', 'Fall Injury', 'INC_MED', 'MED', 3, 'EMS_STANDARD', 'Fall with possible injury', 480, CURRENT_TIMESTAMP()),
('MED-SICK', 'Sick Person', 'INC_MED', 'MED', 3, 'EMS_ROUTINE', 'Non-specific illness complaint', 600, CURRENT_TIMESTAMP()),
('FIRE', 'Fire Emergency', 'INC_FIRE', NULL, 1, 'FIRE_STANDARD', 'General fire emergency', 360, CURRENT_TIMESTAMP()),
('FIRE-STRUCT', 'Structure Fire', 'INC_FIRE_STRUCT', 'FIRE', 1, 'FIRE_FULL', 'Confirmed structure fire', 300, CURRENT_TIMESTAMP()),
('FIRE-WILD', 'Wildfire/Brush', 'INC_FIRE_WILD', 'FIRE', 2, 'FIRE_WILDLAND', 'Wildland or brush fire', 480, CURRENT_TIMESTAMP()),
('FIRE-VEH', 'Vehicle Fire', 'INC_FIRE_VEH', 'FIRE', 2, 'FIRE_SINGLE', 'Motor vehicle fire', 420, CURRENT_TIMESTAMP()),
('FIRE-HAZ', 'Hazmat Incident', 'INC_FIRE_HAZ', 'FIRE', 1, 'HAZMAT', 'Hazardous materials release', 480, CURRENT_TIMESTAMP()),
('FIRE-ALARM', 'Fire Alarm', 'INC_FIRE', 'FIRE', 3, 'FIRE_INVESTIGATE', 'Fire alarm activation - no confirmed fire', 600, CURRENT_TIMESTAMP()),
('LAW', 'Law Enforcement', 'INC_LAW', NULL, 2, 'POLICE_STANDARD', 'General law enforcement incident', 600, CURRENT_TIMESTAMP()),
('LAW-VIOLENT', 'Violent Crime', 'INC_LAW_VIOLENT', 'LAW', 1, 'POLICE_PRIORITY', 'Crime involving violence in progress', 300, CURRENT_TIMESTAMP()),
('LAW-PROPERTY', 'Property Crime', 'INC_LAW_PROPERTY', 'LAW', 3, 'POLICE_ROUTINE', 'Burglary, theft, or property damage', 900, CURRENT_TIMESTAMP()),
('LAW-TRAFFIC', 'Traffic Accident', 'INC_LAW_TRAFFIC', 'LAW', 2, 'POLICE_TRAFFIC', 'Motor vehicle collision', 480, CURRENT_TIMESTAMP()),
('LAW-DOMESTIC', 'Domestic Disturbance', 'INC_LAW_DOMESTIC', 'LAW', 1, 'POLICE_PRIORITY', 'Domestic violence or disturbance', 360, CURRENT_TIMESTAMP()),
('RESCUE', 'Rescue Operation', 'INC_RESCUE', NULL, 1, 'RESCUE_STANDARD', 'Search and rescue operation', 480, CURRENT_TIMESTAMP()),
('RESCUE-WATER', 'Water Rescue', 'INC_RESCUE_WATER', 'RESCUE', 1, 'RESCUE_WATER', 'Drowning or water emergency', 300, CURRENT_TIMESTAMP()),
('RESCUE-TECH', 'Technical Rescue', 'INC_RESCUE_TECH', 'RESCUE', 1, 'RESCUE_TECHNICAL', 'Confined space, collapse, or high-angle', 480, CURRENT_TIMESTAMP());

------------------------------------------------------------------------
-- RESOURCE_TYPE_HIERARCHY: NIMS resource typing
------------------------------------------------------------------------
CREATE OR REPLACE TABLE RESOURCE_TYPE_HIERARCHY (
    RESOURCE_TYPE_CODE  VARCHAR(20) PRIMARY KEY,
    RESOURCE_TYPE_NAME  VARCHAR(100) NOT NULL,
    CLASS_ID            VARCHAR(50) REFERENCES ONTOLOGY_CLASSES(CLASS_ID),
    PARENT_TYPE_CODE    VARCHAR(20),
    MIN_PERSONNEL       NUMBER(3),
    CAPABILITIES        VARCHAR(500),
    NIMS_TYPE_LEVEL     NUMBER(1),
    CREATED_AT          TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP()
);

INSERT INTO RESOURCE_TYPE_HIERARCHY VALUES
('EMS-ALS', 'ALS Ambulance', 'RES_EMS_ALS', NULL, 2, 'Advanced cardiac life support, IV therapy, intubation, cardiac monitoring', 1, CURRENT_TIMESTAMP()),
('EMS-BLS', 'BLS Ambulance', 'RES_EMS_BLS', NULL, 2, 'Basic life support, CPR, AED, oxygen therapy, splinting', 1, CURRENT_TIMESTAMP()),
('EMS-SUPER', 'EMS Supervisor', 'RES_EMS', NULL, 1, 'Field supervision, mass casualty triage, resource coordination', 1, CURRENT_TIMESTAMP()),
('FIRE-ENG', 'Engine Company', 'RES_FIRE_ENGINE', NULL, 4, 'Fire suppression, water supply, initial attack, ventilation', 1, CURRENT_TIMESTAMP()),
('FIRE-LAD', 'Ladder Company', 'RES_FIRE_LADDER', NULL, 4, 'Aerial operations, search and rescue, ventilation, forcible entry', 1, CURRENT_TIMESTAMP()),
('FIRE-RES', 'Rescue Squad', 'RES_FIRE_RESCUE', NULL, 4, 'Heavy rescue, vehicle extrication, confined space, rope rescue', 1, CURRENT_TIMESTAMP()),
('FIRE-BAT', 'Battalion Chief', 'RES_FIRE', NULL, 1, 'Incident command, resource management, safety oversight', 1, CURRENT_TIMESTAMP()),
('FIRE-HAZ', 'Hazmat Unit', 'RES_FIRE', NULL, 4, 'Chemical identification, containment, decontamination', 2, CURRENT_TIMESTAMP()),
('LAW-PAT', 'Patrol Unit', 'RES_LAW_PATROL', NULL, 1, 'Patrol, traffic enforcement, initial investigation, arrest', 1, CURRENT_TIMESTAMP()),
('LAW-DET', 'Detective Unit', 'RES_LAW_DET', NULL, 1, 'Criminal investigation, evidence collection, interviews', 1, CURRENT_TIMESTAMP()),
('LAW-K9', 'K-9 Unit', 'RES_LAW', NULL, 1, 'Tracking, narcotics detection, building search', 2, CURRENT_TIMESTAMP()),
('LAW-SWAT', 'SWAT Team', 'RES_LAW', NULL, 8, 'High-risk warrant service, hostage rescue, active shooter', 3, CURRENT_TIMESTAMP());

------------------------------------------------------------------------
-- REGULATORY_FRAMEWORKS: Standards and regulations
------------------------------------------------------------------------
CREATE OR REPLACE TABLE REGULATORY_FRAMEWORKS (
    FRAMEWORK_ID        VARCHAR(50) PRIMARY KEY,
    FRAMEWORK_NAME      VARCHAR(200) NOT NULL,
    ORGANIZATION        VARCHAR(100),
    DOMAIN              VARCHAR(50),
    DESCRIPTION         VARCHAR(500),
    KEY_REQUIREMENTS    VARCHAR(2000),
    APPLICABLE_CLASSES  ARRAY,
    VERSION             VARCHAR(20),
    CREATED_AT          TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP()
);

INSERT INTO REGULATORY_FRAMEWORKS VALUES
('NFPA-1710', 'Standard for Organization and Deployment of Fire Suppression Operations', 'National Fire Protection Association', 'FIRE',
 'Defines response time objectives and staffing levels for career fire departments',
 'First engine: 4 min travel time, 90th percentile. Full first alarm: 8 min. Staffing: 4 personnel minimum per apparatus. Turnout time: 60-80 seconds.',
 ARRAY_CONSTRUCT('INC_FIRE', 'RES_FIRE', 'METRIC_RESPONSE'), 'v2020', CURRENT_TIMESTAMP()),
('NFPA-1720', 'Standard for Organization and Deployment of Fire Suppression - Volunteer', 'National Fire Protection Association', 'FIRE',
 'Defines response objectives for volunteer and combination fire departments',
 'Urban: 9 min with 15 personnel. Suburban: 10 min with 10 personnel. Rural: 14 min with 6 personnel.',
 ARRAY_CONSTRUCT('INC_FIRE', 'RES_FIRE'), 'v2020', CURRENT_TIMESTAMP()),
('NENA-i3', 'NENA i3 Standard for Next Generation 911', 'National Emergency Number Association', 'OPERATIONS',
 'Technical standard for NG911 systems including call routing, location, and data delivery',
 'Call setup time < 3 seconds. Location accuracy: 50m horizontal, 3m vertical for indoor. ESInet routing. GIS requirements.',
 ARRAY_CONSTRUCT('PROTO_DISPATCH', 'GEO', 'INC'), 'v3.0', CURRENT_TIMESTAMP()),
('MPDS', 'Medical Priority Dispatch System', 'International Academies of Emergency Dispatch', 'MEDICAL',
 'Standardized system for emergency medical call prioritization and pre-arrival instructions',
 '33 chief complaint protocols. Deterministic response levels (OMEGA through ECHO). Scripted pre-arrival instructions. Quality assurance scoring.',
 ARRAY_CONSTRUCT('INC_MED', 'PROTO_MEDICAL', 'METRIC_QUALITY'), 'v13.4', CURRENT_TIMESTAMP()),
('NIMS', 'National Incident Management System', 'FEMA', 'CORE',
 'Comprehensive framework for incident management across all jurisdictions and disciplines',
 'Incident Command System (ICS). Resource typing. Mutual aid. Credentialing. Multi-agency coordination.',
 ARRAY_CONSTRUCT('INC', 'RES', 'PROTO'), 'v3.0', CURRENT_TIMESTAMP()),
('APCO-P33', 'Minimum Training Standards for Telecommunicators', 'Association of Public-Safety Communications Officials', 'OPERATIONS',
 'Minimum training requirements for 911 call-takers and dispatchers',
 '40 hours minimum initial training. Annual continuing education. Call handling procedures. Stress management. Technology proficiency.',
 ARRAY_CONSTRUCT('PROTO_DISPATCH', 'METRIC_QUALITY'), 'v2019', CURRENT_TIMESTAMP());
