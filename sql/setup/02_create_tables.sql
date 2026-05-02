------------------------------------------------------------------------
-- Prepared911 Intelligence Agent
-- File: 02_create_tables.sql
-- Purpose: Create all core data tables in RAW schema
------------------------------------------------------------------------

USE DATABASE PREPARED911_INTELLIGENCE;
USE SCHEMA RAW;
USE WAREHOUSE PREPARED911_WH;

------------------------------------------------------------------------
-- INCIDENT_CALLS: Core 911 call records
------------------------------------------------------------------------
CREATE OR REPLACE TABLE INCIDENT_CALLS (
    CALL_ID             VARCHAR(20) PRIMARY KEY,
    CALL_TIMESTAMP      TIMESTAMP_NTZ NOT NULL,
    CALLER_PHONE        VARCHAR(20),
    CALLER_LOCATION     VARCHAR(200),
    LATITUDE            NUMBER(10,7),
    LONGITUDE           NUMBER(10,7),
    CALL_TYPE           VARCHAR(50) NOT NULL,
    CALL_SUBTYPE        VARCHAR(100),
    PRIORITY            NUMBER(1) NOT NULL,
    LANGUAGE_PRIMARY    VARCHAR(50) DEFAULT 'English',
    TRANSLATION_NEEDED  BOOLEAN DEFAULT FALSE,
    CALL_DURATION_SEC   NUMBER(10),
    HANDLE_TIME_SEC     NUMBER(10),
    DISPOSITION         VARCHAR(50),
    CALL_SOURCE         VARCHAR(30) DEFAULT '911',
    ZONE_ID             VARCHAR(20),
    CALLTAKER_ID        VARCHAR(20),
    CREATED_AT          TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP()
);

------------------------------------------------------------------------
-- INCIDENTS: Incident master records
------------------------------------------------------------------------
CREATE OR REPLACE TABLE INCIDENTS (
    INCIDENT_ID         VARCHAR(20) PRIMARY KEY,
    CALL_ID             VARCHAR(20) REFERENCES INCIDENT_CALLS(CALL_ID),
    INCIDENT_TYPE_CODE  VARCHAR(20) NOT NULL,
    INCIDENT_TYPE_NAME  VARCHAR(100),
    SEVERITY            VARCHAR(20) NOT NULL,
    STATUS              VARCHAR(30) NOT NULL,
    LOCATION_ADDRESS    VARCHAR(300),
    LATITUDE            NUMBER(10,7),
    LONGITUDE           NUMBER(10,7),
    ZONE_ID             VARCHAR(20),
    NARRATIVE           VARCHAR(2000),
    DISPATCH_TIMESTAMP  TIMESTAMP_NTZ,
    FIRST_UNIT_ENROUTE  TIMESTAMP_NTZ,
    FIRST_UNIT_ONSCENE  TIMESTAMP_NTZ,
    INCIDENT_CLOSED     TIMESTAMP_NTZ,
    UNITS_DISPATCHED    NUMBER(5),
    PATIENTS_COUNT      NUMBER(5) DEFAULT 0,
    CREATED_AT          TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP()
);

------------------------------------------------------------------------
-- RESPONSE_UNITS: Units available for dispatch
------------------------------------------------------------------------
CREATE OR REPLACE TABLE RESPONSE_UNITS (
    UNIT_ID             VARCHAR(20) PRIMARY KEY,
    UNIT_NAME           VARCHAR(50) NOT NULL,
    UNIT_TYPE           VARCHAR(30) NOT NULL,
    STATION_ID          VARCHAR(20),
    STATION_NAME        VARCHAR(100),
    STATUS              VARCHAR(20) DEFAULT 'AVAILABLE',
    PERSONNEL_COUNT     NUMBER(3),
    CAPABILITIES        ARRAY,
    VEHICLE_TYPE        VARCHAR(50),
    ZONE_ID             VARCHAR(20),
    LAST_MAINTENANCE    DATE,
    IN_SERVICE_DATE     DATE,
    CREATED_AT          TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP()
);

------------------------------------------------------------------------
-- UNIT_DISPATCHES: Dispatch assignments with timestamps
------------------------------------------------------------------------
CREATE OR REPLACE TABLE UNIT_DISPATCHES (
    DISPATCH_ID         VARCHAR(20) PRIMARY KEY,
    INCIDENT_ID         VARCHAR(20) REFERENCES INCIDENTS(INCIDENT_ID),
    UNIT_ID             VARCHAR(20) REFERENCES RESPONSE_UNITS(UNIT_ID),
    DISPATCH_TIMESTAMP  TIMESTAMP_NTZ NOT NULL,
    ENROUTE_TIMESTAMP   TIMESTAMP_NTZ,
    ONSCENE_TIMESTAMP   TIMESTAMP_NTZ,
    TRANSPORT_TIMESTAMP TIMESTAMP_NTZ,
    AT_HOSPITAL_TIMESTAMP TIMESTAMP_NTZ,
    CLEAR_TIMESTAMP     TIMESTAMP_NTZ,
    RESPONSE_TIME_SEC   NUMBER(10),
    TRAVEL_TIME_SEC     NUMBER(10),
    ON_SCENE_TIME_SEC   NUMBER(10),
    TOTAL_TIME_SEC      NUMBER(10),
    DISTANCE_MILES      NUMBER(6,2),
    DISPOSITION         VARCHAR(50),
    CREATED_AT          TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP()
);

------------------------------------------------------------------------
-- PERSONNEL: Staff records and certifications
------------------------------------------------------------------------
CREATE OR REPLACE TABLE PERSONNEL (
    PERSON_ID           VARCHAR(20) PRIMARY KEY,
    FIRST_NAME          VARCHAR(50),
    LAST_NAME           VARCHAR(50),
    ROLE                VARCHAR(50) NOT NULL,
    BADGE_NUMBER        VARCHAR(20),
    STATION_ID          VARCHAR(20),
    SHIFT               VARCHAR(10),
    CERTIFICATIONS      ARRAY,
    HIRE_DATE           DATE,
    TRAINING_HOURS_YTD  NUMBER(6,1) DEFAULT 0,
    QA_SCORE_AVG        NUMBER(5,2),
    STATUS              VARCHAR(20) DEFAULT 'ACTIVE',
    CREATED_AT          TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP()
);

------------------------------------------------------------------------
-- CALL_TRANSLATIONS: Translation events during calls
------------------------------------------------------------------------
CREATE OR REPLACE TABLE CALL_TRANSLATIONS (
    TRANSLATION_ID      VARCHAR(20) PRIMARY KEY,
    CALL_ID             VARCHAR(20) REFERENCES INCIDENT_CALLS(CALL_ID),
    SOURCE_LANGUAGE     VARCHAR(50) NOT NULL,
    TARGET_LANGUAGE     VARCHAR(50) NOT NULL DEFAULT 'English',
    TRANSLATION_METHOD  VARCHAR(30) NOT NULL,
    AUDIO_TRANSLATED    BOOLEAN DEFAULT FALSE,
    TEXT_TRANSLATED     BOOLEAN DEFAULT FALSE,
    DURATION_SEC        NUMBER(10),
    ACCURACY_SCORE      NUMBER(5,2),
    WORDS_TRANSLATED    NUMBER(10),
    CREATED_AT          TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP()
);

------------------------------------------------------------------------
-- QA_EVALUATIONS: Quality assurance evaluations
------------------------------------------------------------------------
CREATE OR REPLACE TABLE QA_EVALUATIONS (
    EVAL_ID             VARCHAR(20) PRIMARY KEY,
    CALL_ID             VARCHAR(20) REFERENCES INCIDENT_CALLS(CALL_ID),
    EVALUATOR_ID        VARCHAR(20),
    EVAL_TIMESTAMP      TIMESTAMP_NTZ NOT NULL,
    OVERALL_SCORE       NUMBER(5,2) NOT NULL,
    GREETING_SCORE      NUMBER(5,2),
    INFO_GATHERING_SCORE NUMBER(5,2),
    PROTOCOL_ADHERENCE_SCORE NUMBER(5,2),
    COMMUNICATION_SCORE NUMBER(5,2),
    CLOSING_SCORE       NUMBER(5,2),
    AUTO_EVALUATED      BOOLEAN DEFAULT FALSE,
    FEEDBACK_NOTES      VARCHAR(1000),
    IMPROVEMENT_AREAS   ARRAY,
    CREATED_AT          TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP()
);

------------------------------------------------------------------------
-- PROTOCOLS: Response protocols and SOPs
------------------------------------------------------------------------
CREATE OR REPLACE TABLE PROTOCOLS (
    PROTOCOL_ID         VARCHAR(20) PRIMARY KEY,
    PROTOCOL_NAME       VARCHAR(200) NOT NULL,
    CATEGORY            VARCHAR(50) NOT NULL,
    SUBCATEGORY         VARCHAR(50),
    DESCRIPTION         VARCHAR(2000) NOT NULL,
    STEPS               VARCHAR(4000),
    PRIORITY_LEVEL      NUMBER(1),
    EFFECTIVE_DATE      DATE,
    LAST_UPDATED        DATE,
    STATUS              VARCHAR(20) DEFAULT 'ACTIVE',
    APPLICABLE_TYPES    ARRAY,
    REGULATORY_REF      VARCHAR(200),
    CREATED_AT          TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP()
);

------------------------------------------------------------------------
-- GEOGRAPHIC_ZONES: Geographic boundaries and demographics
------------------------------------------------------------------------
CREATE OR REPLACE TABLE GEOGRAPHIC_ZONES (
    ZONE_ID             VARCHAR(20) PRIMARY KEY,
    ZONE_NAME           VARCHAR(100) NOT NULL,
    ZONE_TYPE           VARCHAR(30) NOT NULL,
    DISTRICT            VARCHAR(50),
    POPULATION          NUMBER(10),
    AREA_SQ_MILES       NUMBER(8,2),
    RISK_LEVEL          VARCHAR(20),
    STATIONS_COUNT      NUMBER(3),
    AVG_RESPONSE_TARGET_SEC NUMBER(6),
    LATITUDE_CENTER     NUMBER(10,7),
    LONGITUDE_CENTER    NUMBER(10,7),
    CREATED_AT          TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP()
);
