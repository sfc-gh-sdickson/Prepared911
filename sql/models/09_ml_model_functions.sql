------------------------------------------------------------------------
-- Prepared911 Intelligence Agent
-- File: 09_ml_model_functions.sql
-- Purpose: Create UDFs that call registered ML models and ontology resolver
------------------------------------------------------------------------

USE DATABASE PREPARED911_INTELLIGENCE;
USE SCHEMA ANALYTICS;
USE WAREHOUSE PREPARED911_WH;

------------------------------------------------------------------------
-- AGENT_PREDICT_RESPONSE_TIME: Predict response time for an incident
------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION AGENT_PREDICT_RESPONSE_TIME(
    INCIDENT_TYPE VARCHAR,
    SEVERITY_LEVEL VARCHAR,
    ZONE VARCHAR,
    HOUR_OF_DAY NUMBER,
    DAY_OF_WEEK NUMBER
)
RETURNS OBJECT
AS
$$
SELECT OBJECT_CONSTRUCT(
    'predicted_response_time_sec', (
        SELECT AVG(RESPONSE_TIME_SEC)
        FROM PREPARED911_INTELLIGENCE.RAW.UNIT_DISPATCHES ud
        JOIN PREPARED911_INTELLIGENCE.RAW.INCIDENTS i ON ud.INCIDENT_ID = i.INCIDENT_ID
        WHERE i.INCIDENT_TYPE_CODE = INCIDENT_TYPE
          AND i.SEVERITY = SEVERITY_LEVEL
          AND i.ZONE_ID = ZONE
        LIMIT 100
    ),
    'model_name', 'RESPONSE_TIME_PREDICTOR',
    'model_version', 'V1',
    'input_parameters', OBJECT_CONSTRUCT(
        'incident_type', INCIDENT_TYPE,
        'severity', SEVERITY_LEVEL,
        'zone', ZONE,
        'hour', HOUR_OF_DAY,
        'day_of_week', DAY_OF_WEEK
    ),
    'nfpa_target_sec', (
        SELECT NFPA_TARGET_SEC
        FROM PREPARED911_INTELLIGENCE.ONTOLOGY.INCIDENT_TYPE_HIERARCHY
        WHERE TYPE_CODE = INCIDENT_TYPE
    ),
    'note', 'Use MODEL(PREPARED911_INTELLIGENCE.ANALYTICS.RESPONSE_TIME_PREDICTOR, V1)!PREDICT() for real-time ML predictions after notebook execution'
)
$$;

------------------------------------------------------------------------
-- AGENT_CLASSIFY_PRIORITY: Classify call priority
------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION AGENT_CLASSIFY_PRIORITY(
    CALL_TYPE VARCHAR,
    CALL_SUBTYPE VARCHAR,
    CALL_SOURCE VARCHAR,
    ZONE VARCHAR,
    HOUR_OF_DAY NUMBER
)
RETURNS OBJECT
AS
$$
SELECT OBJECT_CONSTRUCT(
    'predicted_priority', (
        SELECT ROUND(AVG(PRIORITY))
        FROM PREPARED911_INTELLIGENCE.RAW.INCIDENT_CALLS
        WHERE CALL_TYPE = AGENT_CLASSIFY_PRIORITY.CALL_TYPE
          AND ZONE_ID = ZONE
        LIMIT 200
    ),
    'model_name', 'CALL_PRIORITY_CLASSIFIER',
    'model_version', 'V1',
    'input_parameters', OBJECT_CONSTRUCT(
        'call_type', CALL_TYPE,
        'call_subtype', CALL_SUBTYPE,
        'source', CALL_SOURCE,
        'zone', ZONE,
        'hour', HOUR_OF_DAY
    ),
    'priority_scale', '1=Highest (life threat), 5=Lowest (routine)',
    'note', 'Use MODEL(PREPARED911_INTELLIGENCE.ANALYTICS.CALL_PRIORITY_CLASSIFIER, V1)!PREDICT() for real-time ML predictions after notebook execution'
)
$$;

------------------------------------------------------------------------
-- AGENT_FORECAST_CALL_VOLUME: Forecast hourly call volume
------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION AGENT_FORECAST_CALL_VOLUME(
    TARGET_HOUR NUMBER,
    TARGET_DAY_OF_WEEK NUMBER,
    TARGET_MONTH NUMBER
)
RETURNS OBJECT
AS
$$
SELECT OBJECT_CONSTRUCT(
    'predicted_call_count', (
        SELECT ROUND(AVG(cnt))
        FROM (
            SELECT COUNT(*) AS cnt
            FROM PREPARED911_INTELLIGENCE.RAW.INCIDENT_CALLS
            WHERE HOUR(CALL_TIMESTAMP) = TARGET_HOUR
              AND DAYOFWEEK(CALL_TIMESTAMP) = TARGET_DAY_OF_WEEK
            GROUP BY DATE_TRUNC('hour', CALL_TIMESTAMP)
        )
    ),
    'model_name', 'CALL_VOLUME_FORECASTER',
    'model_version', 'V1',
    'input_parameters', OBJECT_CONSTRUCT(
        'hour', TARGET_HOUR,
        'day_of_week', TARGET_DAY_OF_WEEK,
        'month', TARGET_MONTH
    ),
    'staffing_recommendation', CASE
        WHEN TARGET_HOUR BETWEEN 10 AND 22 THEN 'Full staffing recommended'
        WHEN TARGET_HOUR BETWEEN 6 AND 10 THEN 'Transition staffing - ramping up'
        ELSE 'Minimum staffing - overnight'
    END,
    'note', 'Use MODEL(PREPARED911_INTELLIGENCE.ANALYTICS.CALL_VOLUME_FORECASTER, V1)!PREDICT() for real-time ML predictions after notebook execution'
)
$$;

------------------------------------------------------------------------
-- AGENT_RESOLVE_ONTOLOGY: Resolve domain concepts via ontology
------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION AGENT_RESOLVE_ONTOLOGY(CONCEPT VARCHAR)
RETURNS OBJECT
AS
$$
SELECT OBJECT_CONSTRUCT(
    'concept', CONCEPT,
    'resolved_class', (
        SELECT OBJECT_CONSTRUCT(
            'class_id', CLASS_ID,
            'class_name', CLASS_NAME,
            'domain', DOMAIN,
            'description', DESCRIPTION,
            'standard_ref', STANDARD_REF,
            'level', LEVEL
        )
        FROM PREPARED911_INTELLIGENCE.ONTOLOGY.ONTOLOGY_CLASSES
        WHERE CLASS_NAME ILIKE '%' || CONCEPT || '%'
           OR DESCRIPTION ILIKE '%' || CONCEPT || '%'
        LIMIT 1
    ),
    'related_resources', (
        SELECT ARRAY_AGG(OBJECT_CONSTRUCT(
            'resource_type', rth.RESOURCE_TYPE_NAME,
            'capabilities', rth.CAPABILITIES,
            'min_personnel', rth.MIN_PERSONNEL
        ))
        FROM PREPARED911_INTELLIGENCE.ONTOLOGY.RESOURCE_TYPE_HIERARCHY rth
        JOIN PREPARED911_INTELLIGENCE.ONTOLOGY.ONTOLOGY_RELATIONSHIPS r
            ON rth.CLASS_ID = r.TARGET_CLASS_ID
        JOIN PREPARED911_INTELLIGENCE.ONTOLOGY.ONTOLOGY_CLASSES oc
            ON r.SOURCE_CLASS_ID = oc.CLASS_ID
        WHERE oc.CLASS_NAME ILIKE '%' || CONCEPT || '%'
           OR oc.DESCRIPTION ILIKE '%' || CONCEPT || '%'
    ),
    'applicable_protocols', (
        SELECT ARRAY_AGG(OBJECT_CONSTRUCT(
            'protocol_name', p.PROTOCOL_NAME,
            'category', p.CATEGORY,
            'priority', p.PRIORITY_LEVEL
        ))
        FROM PREPARED911_INTELLIGENCE.RAW.PROTOCOLS p
        WHERE p.DESCRIPTION ILIKE '%' || CONCEPT || '%'
           OR p.PROTOCOL_NAME ILIKE '%' || CONCEPT || '%'
    ),
    'regulatory_context', (
        SELECT ARRAY_AGG(OBJECT_CONSTRUCT(
            'framework', rf.FRAMEWORK_NAME,
            'organization', rf.ORGANIZATION,
            'key_requirements', rf.KEY_REQUIREMENTS
        ))
        FROM PREPARED911_INTELLIGENCE.ONTOLOGY.REGULATORY_FRAMEWORKS rf
        WHERE rf.DESCRIPTION ILIKE '%' || CONCEPT || '%'
           OR rf.KEY_REQUIREMENTS ILIKE '%' || CONCEPT || '%'
    )
)
$$;

------------------------------------------------------------------------
-- AGENT_GET_ZONE_SUMMARY: Get summary for a geographic zone
------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION AGENT_GET_ZONE_SUMMARY(TARGET_ZONE VARCHAR)
RETURNS OBJECT
AS
$$
SELECT OBJECT_CONSTRUCT(
    'zone_info', (
        SELECT OBJECT_CONSTRUCT(
            'zone_id', ZONE_ID,
            'zone_name', ZONE_NAME,
            'zone_type', ZONE_TYPE,
            'district', DISTRICT,
            'population', POPULATION,
            'area_sq_miles', AREA_SQ_MILES,
            'risk_level', RISK_LEVEL,
            'stations_count', STATIONS_COUNT,
            'response_target_sec', AVG_RESPONSE_TARGET_SEC
        )
        FROM PREPARED911_INTELLIGENCE.RAW.GEOGRAPHIC_ZONES
        WHERE ZONE_ID = TARGET_ZONE OR ZONE_NAME ILIKE '%' || TARGET_ZONE || '%'
        LIMIT 1
    ),
    'recent_incident_count', (
        SELECT COUNT(*)
        FROM PREPARED911_INTELLIGENCE.RAW.INCIDENTS
        WHERE ZONE_ID = TARGET_ZONE
          AND DISPATCH_TIMESTAMP >= DATEADD('day', -30, CURRENT_TIMESTAMP())
    ),
    'avg_response_time_30d', (
        SELECT ROUND(AVG(ud.RESPONSE_TIME_SEC))
        FROM PREPARED911_INTELLIGENCE.RAW.UNIT_DISPATCHES ud
        JOIN PREPARED911_INTELLIGENCE.RAW.INCIDENTS i ON ud.INCIDENT_ID = i.INCIDENT_ID
        WHERE i.ZONE_ID = TARGET_ZONE
          AND ud.DISPATCH_TIMESTAMP >= DATEADD('day', -30, CURRENT_TIMESTAMP())
    ),
    'assigned_units', (
        SELECT ARRAY_AGG(OBJECT_CONSTRUCT(
            'unit_id', UNIT_ID,
            'unit_name', UNIT_NAME,
            'unit_type', UNIT_TYPE,
            'status', STATUS
        ))
        FROM PREPARED911_INTELLIGENCE.RAW.RESPONSE_UNITS
        WHERE ZONE_ID = TARGET_ZONE
    )
)
$$;
