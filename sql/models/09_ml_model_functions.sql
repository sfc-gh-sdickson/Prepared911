------------------------------------------------------------------------
-- Prepared911 Intelligence Agent
-- File: 09_ml_model_functions.sql
-- Purpose: Create UDFs that call registered ML models and ontology resolver
--
-- NOTE: The ML prediction functions below use MODEL()!PREDICT() to call
-- models registered in the Snowflake Model Registry. The models MUST be
-- registered first by running notebooks/08_ml_models.ipynb.
-- If models are not yet registered, these functions will error.
------------------------------------------------------------------------

USE DATABASE PREPARED911_INTELLIGENCE;
USE SCHEMA ANALYTICS;
USE WAREHOUSE PREPARED911_WH;

------------------------------------------------------------------------
-- AGENT_PREDICT_RESPONSE_TIME: Predict response time using registered model
------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION AGENT_PREDICT_RESPONSE_TIME(
    TYPE_ENCODED NUMBER,
    SEVERITY_ENCODED NUMBER,
    ZONE_ENCODED NUMBER,
    ZONE_TYPE_ENCODED NUMBER,
    RISK_ENCODED NUMBER,
    HOUR_OF_DAY NUMBER,
    DAY_OF_WEEK NUMBER,
    UNITS_DISPATCHED NUMBER,
    POPULATION_VAL NUMBER
)
RETURNS OBJECT
AS
$$
SELECT OBJECT_CONSTRUCT(
    'predicted_response_time_sec', (
        SELECT MODEL(PREPARED911_INTELLIGENCE.ANALYTICS.RESPONSE_TIME_PREDICTOR, 'V1')!PREDICT(
            TYPE_ENCODED, SEVERITY_ENCODED, ZONE_ENCODED, ZONE_TYPE_ENCODED,
            RISK_ENCODED, HOUR_OF_DAY, DAY_OF_WEEK, UNITS_DISPATCHED, POPULATION_VAL
        ):output_feature_0::NUMBER
    ),
    'model_name', 'RESPONSE_TIME_PREDICTOR',
    'model_version', 'V1',
    'input_parameters', OBJECT_CONSTRUCT(
        'type_encoded', TYPE_ENCODED,
        'severity_encoded', SEVERITY_ENCODED,
        'zone_encoded', ZONE_ENCODED,
        'zone_type_encoded', ZONE_TYPE_ENCODED,
        'risk_encoded', RISK_ENCODED,
        'hour', HOUR_OF_DAY,
        'day_of_week', DAY_OF_WEEK,
        'units_dispatched', UNITS_DISPATCHED,
        'population', POPULATION_VAL
    )
)
$$;

------------------------------------------------------------------------
-- AGENT_CLASSIFY_PRIORITY: Classify call priority using registered model
------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION AGENT_CLASSIFY_PRIORITY(
    CALL_TYPE_ENCODED NUMBER,
    SUBTYPE_ENCODED NUMBER,
    SOURCE_ENCODED NUMBER,
    ZONE_ENCODED NUMBER,
    HOUR_OF_DAY NUMBER,
    DAY_OF_WEEK NUMBER,
    TRANSLATION_INT NUMBER
)
RETURNS OBJECT
AS
$$
SELECT OBJECT_CONSTRUCT(
    'predicted_priority', (
        SELECT MODEL(PREPARED911_INTELLIGENCE.ANALYTICS.CALL_PRIORITY_CLASSIFIER, 'V1')!PREDICT(
            CALL_TYPE_ENCODED, SUBTYPE_ENCODED, SOURCE_ENCODED,
            ZONE_ENCODED, HOUR_OF_DAY, DAY_OF_WEEK, TRANSLATION_INT
        ):output_feature_0::NUMBER
    ),
    'model_name', 'CALL_PRIORITY_CLASSIFIER',
    'model_version', 'V1',
    'priority_scale', '1=Highest (life threat), 5=Lowest (routine)',
    'input_parameters', OBJECT_CONSTRUCT(
        'call_type_encoded', CALL_TYPE_ENCODED,
        'subtype_encoded', SUBTYPE_ENCODED,
        'source_encoded', SOURCE_ENCODED,
        'zone_encoded', ZONE_ENCODED,
        'hour', HOUR_OF_DAY,
        'day_of_week', DAY_OF_WEEK,
        'translation_int', TRANSLATION_INT
    )
)
$$;

------------------------------------------------------------------------
-- AGENT_FORECAST_CALL_VOLUME: Forecast hourly call volume using model
------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION AGENT_FORECAST_CALL_VOLUME(
    HOUR_OF_DAY NUMBER,
    DAY_OF_WEEK NUMBER,
    MONTH_NUM NUMBER,
    IS_WEEKEND NUMBER,
    IS_NIGHT NUMBER,
    HOUR_SIN FLOAT,
    HOUR_COS FLOAT,
    DOW_SIN FLOAT,
    DOW_COS FLOAT
)
RETURNS OBJECT
AS
$$
SELECT OBJECT_CONSTRUCT(
    'predicted_call_count', (
        SELECT MODEL(PREPARED911_INTELLIGENCE.ANALYTICS.CALL_VOLUME_FORECASTER, 'V1')!PREDICT(
            HOUR_OF_DAY, DAY_OF_WEEK, MONTH_NUM, IS_WEEKEND,
            IS_NIGHT, HOUR_SIN, HOUR_COS, DOW_SIN, DOW_COS
        ):output_feature_0::NUMBER
    ),
    'model_name', 'CALL_VOLUME_FORECASTER',
    'model_version', 'V1',
    'input_parameters', OBJECT_CONSTRUCT(
        'hour', HOUR_OF_DAY,
        'day_of_week', DAY_OF_WEEK,
        'month', MONTH_NUM
    ),
    'staffing_recommendation', CASE
        WHEN HOUR_OF_DAY BETWEEN 10 AND 22 THEN 'Full staffing recommended'
        WHEN HOUR_OF_DAY BETWEEN 6 AND 10 THEN 'Transition staffing - ramping up'
        ELSE 'Minimum staffing - overnight'
    END
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
