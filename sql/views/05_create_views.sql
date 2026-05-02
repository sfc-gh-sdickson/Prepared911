------------------------------------------------------------------------
-- Prepared911 Intelligence Agent
-- File: 05_create_views.sql
-- Purpose: Create analytical views for reporting and analysis
------------------------------------------------------------------------

USE DATABASE PREPARED911_INTELLIGENCE;
USE SCHEMA ANALYTICS;
USE WAREHOUSE PREPARED911_WH;

------------------------------------------------------------------------
-- V_RESPONSE_TIME_ANALYSIS: Response time metrics by zone and type
------------------------------------------------------------------------
CREATE OR REPLACE VIEW V_RESPONSE_TIME_ANALYSIS AS
SELECT
    i.INCIDENT_ID,
    i.INCIDENT_TYPE_CODE,
    i.INCIDENT_TYPE_NAME,
    i.SEVERITY,
    i.ZONE_ID,
    gz.ZONE_NAME,
    gz.ZONE_TYPE,
    gz.DISTRICT,
    gz.RISK_LEVEL,
    i.DISPATCH_TIMESTAMP,
    DATE_TRUNC('month', i.DISPATCH_TIMESTAMP) AS INCIDENT_MONTH,
    DATE_TRUNC('week', i.DISPATCH_TIMESTAMP) AS INCIDENT_WEEK,
    DAYNAME(i.DISPATCH_TIMESTAMP) AS DAY_OF_WEEK,
    HOUR(i.DISPATCH_TIMESTAMP) AS HOUR_OF_DAY,
    ud.RESPONSE_TIME_SEC,
    ud.TRAVEL_TIME_SEC,
    ud.ON_SCENE_TIME_SEC,
    ud.TOTAL_TIME_SEC,
    ud.DISTANCE_MILES,
    ud.UNIT_ID,
    ru.UNIT_TYPE,
    ru.STATION_NAME,
    ith.NFPA_TARGET_SEC,
    CASE WHEN ud.RESPONSE_TIME_SEC <= ith.NFPA_TARGET_SEC THEN TRUE ELSE FALSE END AS MEETS_TARGET,
    i.UNITS_DISPATCHED,
    i.STATUS AS INCIDENT_STATUS
FROM RAW.INCIDENTS i
LEFT JOIN RAW.UNIT_DISPATCHES ud ON i.INCIDENT_ID = ud.INCIDENT_ID
LEFT JOIN RAW.RESPONSE_UNITS ru ON ud.UNIT_ID = ru.UNIT_ID
LEFT JOIN RAW.GEOGRAPHIC_ZONES gz ON i.ZONE_ID = gz.ZONE_ID
LEFT JOIN ONTOLOGY.INCIDENT_TYPE_HIERARCHY ith ON i.INCIDENT_TYPE_CODE = ith.TYPE_CODE;

------------------------------------------------------------------------
-- V_CALL_VOLUME_TRENDS: Call volume patterns and trends
------------------------------------------------------------------------
CREATE OR REPLACE VIEW V_CALL_VOLUME_TRENDS AS
SELECT
    DATE_TRUNC('hour', c.CALL_TIMESTAMP) AS CALL_HOUR,
    DATE_TRUNC('day', c.CALL_TIMESTAMP) AS CALL_DATE,
    DATE_TRUNC('week', c.CALL_TIMESTAMP) AS CALL_WEEK,
    DATE_TRUNC('month', c.CALL_TIMESTAMP) AS CALL_MONTH,
    DAYNAME(c.CALL_TIMESTAMP) AS DAY_OF_WEEK,
    HOUR(c.CALL_TIMESTAMP) AS HOUR_OF_DAY,
    c.CALL_TYPE,
    c.PRIORITY,
    c.ZONE_ID,
    gz.ZONE_NAME,
    gz.DISTRICT,
    c.LANGUAGE_PRIMARY,
    c.TRANSLATION_NEEDED,
    c.CALL_SOURCE,
    c.DISPOSITION,
    COUNT(*) AS CALL_COUNT,
    AVG(c.CALL_DURATION_SEC) AS AVG_CALL_DURATION,
    AVG(c.HANDLE_TIME_SEC) AS AVG_HANDLE_TIME,
    SUM(CASE WHEN c.TRANSLATION_NEEDED THEN 1 ELSE 0 END) AS TRANSLATION_CALLS
FROM RAW.INCIDENT_CALLS c
LEFT JOIN RAW.GEOGRAPHIC_ZONES gz ON c.ZONE_ID = gz.ZONE_ID
GROUP BY ALL;

------------------------------------------------------------------------
-- V_QA_PERFORMANCE: Quality assurance performance tracking
------------------------------------------------------------------------
CREATE OR REPLACE VIEW V_QA_PERFORMANCE AS
SELECT
    qa.EVAL_ID,
    qa.CALL_ID,
    qa.EVALUATOR_ID,
    qa.EVAL_TIMESTAMP,
    DATE_TRUNC('month', qa.EVAL_TIMESTAMP) AS EVAL_MONTH,
    DATE_TRUNC('week', qa.EVAL_TIMESTAMP) AS EVAL_WEEK,
    qa.OVERALL_SCORE,
    qa.GREETING_SCORE,
    qa.INFO_GATHERING_SCORE,
    qa.PROTOCOL_ADHERENCE_SCORE,
    qa.COMMUNICATION_SCORE,
    qa.CLOSING_SCORE,
    qa.AUTO_EVALUATED,
    qa.FEEDBACK_NOTES,
    c.CALL_TYPE,
    c.PRIORITY,
    c.CALLTAKER_ID,
    p.FIRST_NAME || ' ' || p.LAST_NAME AS CALLTAKER_NAME,
    p.SHIFT,
    p.HIRE_DATE,
    DATEDIFF('year', p.HIRE_DATE, CURRENT_DATE()) AS YEARS_EXPERIENCE,
    c.TRANSLATION_NEEDED,
    c.LANGUAGE_PRIMARY
FROM RAW.QA_EVALUATIONS qa
LEFT JOIN RAW.INCIDENT_CALLS c ON qa.CALL_ID = c.CALL_ID
LEFT JOIN RAW.PERSONNEL p ON c.CALLTAKER_ID = p.PERSON_ID;

------------------------------------------------------------------------
-- V_UNIT_UTILIZATION: Resource utilization metrics
------------------------------------------------------------------------
CREATE OR REPLACE VIEW V_UNIT_UTILIZATION AS
SELECT
    ru.UNIT_ID,
    ru.UNIT_NAME,
    ru.UNIT_TYPE,
    ru.STATION_NAME,
    ru.ZONE_ID,
    gz.ZONE_NAME,
    DATE_TRUNC('month', ud.DISPATCH_TIMESTAMP) AS DISPATCH_MONTH,
    COUNT(ud.DISPATCH_ID) AS DISPATCH_COUNT,
    AVG(ud.RESPONSE_TIME_SEC) AS AVG_RESPONSE_TIME,
    AVG(ud.TOTAL_TIME_SEC) AS AVG_TOTAL_TIME,
    SUM(ud.TOTAL_TIME_SEC) AS TOTAL_BUSY_TIME_SEC,
    AVG(ud.DISTANCE_MILES) AS AVG_DISTANCE
FROM RAW.RESPONSE_UNITS ru
LEFT JOIN RAW.UNIT_DISPATCHES ud ON ru.UNIT_ID = ud.UNIT_ID
LEFT JOIN RAW.GEOGRAPHIC_ZONES gz ON ru.ZONE_ID = gz.ZONE_ID
GROUP BY ALL;

------------------------------------------------------------------------
-- V_TRANSLATION_ANALYTICS: Translation service usage and performance
------------------------------------------------------------------------
CREATE OR REPLACE VIEW V_TRANSLATION_ANALYTICS AS
SELECT
    ct.TRANSLATION_ID,
    ct.CALL_ID,
    ct.SOURCE_LANGUAGE,
    ct.TARGET_LANGUAGE,
    ct.TRANSLATION_METHOD,
    ct.AUDIO_TRANSLATED,
    ct.TEXT_TRANSLATED,
    ct.DURATION_SEC,
    ct.ACCURACY_SCORE,
    ct.WORDS_TRANSLATED,
    c.CALL_TIMESTAMP,
    DATE_TRUNC('month', c.CALL_TIMESTAMP) AS CALL_MONTH,
    c.CALL_TYPE,
    c.PRIORITY,
    c.ZONE_ID,
    c.CALL_DURATION_SEC,
    c.HANDLE_TIME_SEC
FROM RAW.CALL_TRANSLATIONS ct
JOIN RAW.INCIDENT_CALLS c ON ct.CALL_ID = c.CALL_ID;
