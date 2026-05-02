------------------------------------------------------------------------
-- Prepared911 Intelligence Agent
-- File: 06_create_semantic_views.sql
-- Purpose: Create semantic views for Cortex Analyst text-to-SQL
------------------------------------------------------------------------

USE DATABASE PREPARED911_INTELLIGENCE;
USE SCHEMA ANALYTICS;
USE WAREHOUSE PREPARED911_WH;

------------------------------------------------------------------------
-- SV_INCIDENT_OPERATIONS: Incident response operations metrics
------------------------------------------------------------------------
CREATE OR REPLACE SEMANTIC VIEW SV_INCIDENT_OPERATIONS

  TABLES (
    incidents AS PREPARED911_INTELLIGENCE.RAW.INCIDENTS
      PRIMARY KEY (INCIDENT_ID)
      WITH SYNONYMS ('incidents', 'events', 'calls for service', '911 incidents')
      COMMENT = 'Master table of all emergency incidents dispatched through 911',
    unit_dispatches AS PREPARED911_INTELLIGENCE.RAW.UNIT_DISPATCHES
      PRIMARY KEY (DISPATCH_ID)
      WITH SYNONYMS ('dispatches', 'responses', 'unit assignments')
      COMMENT = 'Records of individual unit responses to incidents with timestamps',
    zones AS PREPARED911_INTELLIGENCE.RAW.GEOGRAPHIC_ZONES
      PRIMARY KEY (ZONE_ID)
      WITH SYNONYMS ('zones', 'areas', 'districts', 'neighborhoods')
      COMMENT = 'Geographic response zones with population and risk data',
    units AS PREPARED911_INTELLIGENCE.RAW.RESPONSE_UNITS
      PRIMARY KEY (UNIT_ID)
      WITH SYNONYMS ('units', 'apparatus', 'vehicles', 'resources')
      COMMENT = 'Response units available for dispatch'
  )

  RELATIONSHIPS (
    incident_to_zone AS
      incidents (ZONE_ID) REFERENCES zones,
    dispatch_to_incident AS
      unit_dispatches (INCIDENT_ID) REFERENCES incidents,
    dispatch_to_unit AS
      unit_dispatches (UNIT_ID) REFERENCES units
  )

  FACTS (
    unit_dispatches.response_time_val AS RESPONSE_TIME_SEC
      COMMENT = 'Time in seconds from dispatch to unit arriving on scene',
    unit_dispatches.travel_time_val AS TRAVEL_TIME_SEC
      COMMENT = 'Time in seconds spent traveling to scene',
    unit_dispatches.on_scene_time_val AS ON_SCENE_TIME_SEC
      COMMENT = 'Time in seconds spent on scene',
    unit_dispatches.total_time_val AS TOTAL_TIME_SEC
      COMMENT = 'Total time in seconds for entire response',
    unit_dispatches.distance_val AS DISTANCE_MILES
      COMMENT = 'Distance traveled in miles'
  )

  DIMENSIONS (
    incidents.incident_type AS INCIDENT_TYPE_CODE
      WITH SYNONYMS = ('type', 'call type', 'incident category')
      COMMENT = 'Standardized incident type classification code',
    incidents.incident_type_desc AS INCIDENT_TYPE_NAME
      WITH SYNONYMS = ('incident name', 'type name', 'category name')
      COMMENT = 'Human-readable name of the incident type',
    incidents.incident_severity AS SEVERITY
      WITH SYNONYMS = ('severity level', 'priority', 'criticality')
      COMMENT = 'Incident severity: CRITICAL, MAJOR, MODERATE, MINOR, ROUTINE',
    incidents.incident_status AS STATUS
      WITH SYNONYMS = ('status', 'state', 'disposition')
      COMMENT = 'Current status of the incident: ACTIVE, IN_PROGRESS, CLOSED',
    incidents.incident_date AS DISPATCH_TIMESTAMP
      WITH SYNONYMS = ('date', 'time', 'when', 'timestamp')
      COMMENT = 'Date and time the incident was dispatched',
    incidents.incident_month AS MONTH(DISPATCH_TIMESTAMP)
      WITH SYNONYMS = ('month')
      COMMENT = 'Month of incident dispatch',
    incidents.incident_zone AS ZONE_ID
      COMMENT = 'Geographic zone identifier',
    zones.zone_name_dim AS ZONE_NAME
      WITH SYNONYMS = ('area name', 'neighborhood', 'district name')
      COMMENT = 'Name of the geographic response zone',
    zones.zone_type_dim AS ZONE_TYPE
      WITH SYNONYMS = ('area type', 'urban or suburban')
      COMMENT = 'Classification of zone: URBAN, SUBURBAN, INDUSTRIAL',
    zones.risk_level_dim AS RISK_LEVEL
      WITH SYNONYMS = ('risk', 'danger level')
      COMMENT = 'Zone risk classification: HIGH, MEDIUM, LOW',
    zones.district_dim AS DISTRICT
      WITH SYNONYMS = ('district', 'region')
      COMMENT = 'Administrative district containing the zone',
    units.unit_type_dim AS UNIT_TYPE
      WITH SYNONYMS = ('apparatus type', 'vehicle type', 'resource type')
      COMMENT = 'Type of response unit: ENGINE, LADDER, ALS_AMBULANCE, PATROL',
    units.station_dim AS STATION_NAME
      WITH SYNONYMS = ('station', 'firehouse', 'base')
      COMMENT = 'Name of station where unit is based'
  )

  METRICS (
    incidents.total_incidents AS COUNT(INCIDENT_ID)
      WITH SYNONYMS = ('incident count', 'number of incidents', 'call count')
      COMMENT = 'Total number of incidents',
    incidents.units_per_incident AS AVG(UNITS_DISPATCHED)
      WITH SYNONYMS = ('average units', 'resources per call')
      COMMENT = 'Average number of units dispatched per incident',
    unit_dispatches.avg_response_time AS AVG(unit_dispatches.response_time_val)
      WITH SYNONYMS = ('average response time', 'mean response time')
      COMMENT = 'Average response time in seconds across all dispatches',
    unit_dispatches.median_response_time AS MEDIAN(unit_dispatches.response_time_val)
      WITH SYNONYMS = ('median response time', '50th percentile response')
      COMMENT = 'Median response time in seconds',
    unit_dispatches.total_dispatches AS COUNT(DISPATCH_ID)
      WITH SYNONYMS = ('dispatch count', 'number of responses')
      COMMENT = 'Total number of unit dispatch events',
    unit_dispatches.avg_travel_time AS AVG(unit_dispatches.travel_time_val)
      WITH SYNONYMS = ('average travel time', 'mean travel time')
      COMMENT = 'Average travel time in seconds',
    unit_dispatches.avg_on_scene_time AS AVG(unit_dispatches.on_scene_time_val)
      WITH SYNONYMS = ('average scene time', 'time on scene')
      COMMENT = 'Average time spent on scene in seconds',
    unit_dispatches.avg_distance AS AVG(unit_dispatches.distance_val)
      WITH SYNONYMS = ('average distance', 'mean distance')
      COMMENT = 'Average distance traveled in miles'
  )

  COMMENT = 'Semantic view for emergency incident operations analysis including response times, dispatch patterns, and resource deployment metrics';

------------------------------------------------------------------------
-- SV_CALL_CENTER_PERFORMANCE: Call processing and center metrics
------------------------------------------------------------------------
CREATE OR REPLACE SEMANTIC VIEW SV_CALL_CENTER_PERFORMANCE

  TABLES (
    calls AS PREPARED911_INTELLIGENCE.RAW.INCIDENT_CALLS
      PRIMARY KEY (CALL_ID)
      WITH SYNONYMS ('calls', '911 calls', 'emergency calls', 'incoming calls')
      COMMENT = 'All 911 and non-emergency calls received by the call center',
    translations AS PREPARED911_INTELLIGENCE.RAW.CALL_TRANSLATIONS
      PRIMARY KEY (TRANSLATION_ID)
      WITH SYNONYMS ('translations', 'language services', 'interpreter calls')
      COMMENT = 'Translation services used during call processing',
    qa AS PREPARED911_INTELLIGENCE.RAW.QA_EVALUATIONS
      PRIMARY KEY (EVAL_ID)
      WITH SYNONYMS ('evaluations', 'QA scores', 'quality reviews')
      COMMENT = 'Quality assurance evaluations of call-taker performance',
    zones AS PREPARED911_INTELLIGENCE.RAW.GEOGRAPHIC_ZONES
      PRIMARY KEY (ZONE_ID)
      WITH SYNONYMS ('zones', 'areas')
      COMMENT = 'Geographic response zones'
  )

  RELATIONSHIPS (
    call_to_zone AS
      calls (ZONE_ID) REFERENCES zones,
    translation_to_call AS
      translations (CALL_ID) REFERENCES calls,
    qa_to_call AS
      qa (CALL_ID) REFERENCES calls
  )

  FACTS (
    calls.call_duration_val AS CALL_DURATION_SEC
      COMMENT = 'Total duration of the 911 call in seconds',
    calls.handle_time_val AS HANDLE_TIME_SEC
      COMMENT = 'Time from answer to dispatch in seconds',
    translations.translation_duration_val AS DURATION_SEC
      COMMENT = 'Duration of translation service usage in seconds',
    translations.accuracy_val AS ACCURACY_SCORE
      COMMENT = 'AI translation accuracy score (0-100)'
  )

  DIMENSIONS (
    calls.call_type_dim AS CALL_TYPE
      WITH SYNONYMS = ('type', 'category', 'call category')
      COMMENT = 'Type of call: MEDICAL, FIRE, LAW_ENFORCEMENT, TRAFFIC, etc.',
    calls.call_priority AS PRIORITY
      WITH SYNONYMS = ('priority level', 'urgency')
      COMMENT = 'Call priority level from 1 (highest) to 5 (lowest)',
    calls.call_language AS LANGUAGE_PRIMARY
      WITH SYNONYMS = ('language', 'caller language', 'spoken language')
      COMMENT = 'Primary language of the caller',
    calls.needs_translation AS TRANSLATION_NEEDED
      WITH SYNONYMS = ('translated', 'non-english', 'language barrier')
      COMMENT = 'Whether the call required translation services',
    calls.call_source_dim AS CALL_SOURCE
      WITH SYNONYMS = ('source', 'origin', 'how received')
      COMMENT = 'Source of the call: 911, NON_EMERGENCY, TEXT_911, TRANSFER',
    calls.call_disposition AS DISPOSITION
      WITH SYNONYMS = ('outcome', 'result', 'call result')
      COMMENT = 'Final disposition: DISPATCHED, INFORMATION_ONLY, TRANSFERRED',
    calls.call_date AS CALL_TIMESTAMP
      WITH SYNONYMS = ('date', 'time', 'when called')
      COMMENT = 'Date and time the call was received',
    calls.call_month AS MONTH(CALL_TIMESTAMP)
      WITH SYNONYMS = ('month')
      COMMENT = 'Month when call was received',
    calls.call_hour AS HOUR(CALL_TIMESTAMP)
      WITH SYNONYMS = ('hour', 'time of day')
      COMMENT = 'Hour of day when call was received (0-23)',
    calls.call_zone AS ZONE_ID
      COMMENT = 'Zone from which the call originated',
    zones.zone_name_dim AS ZONE_NAME
      WITH SYNONYMS = ('area', 'neighborhood')
      COMMENT = 'Name of the geographic zone',
    translations.source_lang AS SOURCE_LANGUAGE
      WITH SYNONYMS = ('from language', 'original language')
      COMMENT = 'Language being translated from',
    translations.method_dim AS TRANSLATION_METHOD
      WITH SYNONYMS = ('translation type', 'how translated')
      COMMENT = 'Method used: AUDIO_AI, TEXT_AI, TEXT_TO_VOICE'
  )

  METRICS (
    calls.total_calls AS COUNT(CALL_ID)
      WITH SYNONYMS = ('call count', 'number of calls', 'call volume')
      COMMENT = 'Total number of calls received',
    calls.avg_call_duration AS AVG(calls.call_duration_val)
      WITH SYNONYMS = ('average call length', 'mean call duration')
      COMMENT = 'Average call duration in seconds',
    calls.avg_handle_time AS AVG(calls.handle_time_val)
      WITH SYNONYMS = ('average handle time', 'processing time')
      COMMENT = 'Average handle time in seconds',
    calls.translation_call_count AS COUNT_IF(calls.needs_translation = TRUE)
      WITH SYNONYMS = ('translated calls', 'non-english calls')
      COMMENT = 'Number of calls that required translation',
    translations.avg_accuracy AS AVG(translations.accuracy_val)
      WITH SYNONYMS = ('translation accuracy', 'AI accuracy')
      COMMENT = 'Average translation accuracy score',
    qa.avg_qa_score AS AVG(qa.OVERALL_SCORE)
      WITH SYNONYMS = ('quality score', 'QA score', 'average quality')
      COMMENT = 'Average overall QA evaluation score',
    qa.total_evaluations AS COUNT(qa.EVAL_ID)
      WITH SYNONYMS = ('evaluation count', 'reviews completed')
      COMMENT = 'Total number of QA evaluations performed'
  )

  COMMENT = 'Semantic view for 911 call center performance metrics including call volumes, handle times, translation usage, and quality scores';

------------------------------------------------------------------------
-- SV_RESOURCE_MANAGEMENT: Unit and personnel management metrics
------------------------------------------------------------------------
CREATE OR REPLACE SEMANTIC VIEW SV_RESOURCE_MANAGEMENT

  TABLES (
    units AS PREPARED911_INTELLIGENCE.RAW.RESPONSE_UNITS
      PRIMARY KEY (UNIT_ID)
      WITH SYNONYMS ('units', 'apparatus', 'vehicles', 'resources', 'assets')
      COMMENT = 'Response units available for emergency dispatch',
    dispatches AS PREPARED911_INTELLIGENCE.RAW.UNIT_DISPATCHES
      PRIMARY KEY (DISPATCH_ID)
      WITH SYNONYMS ('dispatches', 'deployments', 'assignments')
      COMMENT = 'Unit dispatch records with response timestamps',
    personnel AS PREPARED911_INTELLIGENCE.RAW.PERSONNEL
      PRIMARY KEY (PERSON_ID)
      WITH SYNONYMS ('staff', 'employees', 'personnel', 'team members')
      COMMENT = 'Emergency response personnel records',
    zones AS PREPARED911_INTELLIGENCE.RAW.GEOGRAPHIC_ZONES
      PRIMARY KEY (ZONE_ID)
      WITH SYNONYMS ('zones', 'areas', 'coverage areas')
      COMMENT = 'Geographic zones served by response units'
  )

  RELATIONSHIPS (
    unit_to_zone AS
      units (ZONE_ID) REFERENCES zones,
    dispatch_to_unit AS
      dispatches (UNIT_ID) REFERENCES units,
    personnel_to_station AS
      personnel (STATION_ID) REFERENCES units (STATION_ID)
  )

  FACTS (
    dispatches.response_time_fact AS RESPONSE_TIME_SEC
      COMMENT = 'Response time in seconds for this dispatch',
    dispatches.total_time_fact AS TOTAL_TIME_SEC
      COMMENT = 'Total busy time in seconds for this dispatch',
    dispatches.distance_fact AS DISTANCE_MILES
      COMMENT = 'Distance traveled for this dispatch in miles',
    personnel.training_hours AS TRAINING_HOURS_YTD
      COMMENT = 'Year-to-date training hours completed',
    personnel.qa_avg AS QA_SCORE_AVG
      COMMENT = 'Average QA score for this person'
  )

  DIMENSIONS (
    units.unit_name_dim AS UNIT_NAME
      WITH SYNONYMS = ('unit', 'apparatus name')
      COMMENT = 'Name identifier of the response unit',
    units.unit_type_dim AS UNIT_TYPE
      WITH SYNONYMS = ('type', 'apparatus type', 'vehicle category')
      COMMENT = 'Classification of unit: ENGINE, LADDER, ALS_AMBULANCE, PATROL, etc.',
    units.station_dim AS STATION_NAME
      WITH SYNONYMS = ('station', 'home station', 'base')
      COMMENT = 'Station where unit is based',
    units.unit_status AS STATUS
      WITH SYNONYMS = ('availability', 'current status')
      COMMENT = 'Current unit status: AVAILABLE, ON_CALL, OUT_OF_SERVICE',
    zones.zone_name_dim AS ZONE_NAME
      WITH SYNONYMS = ('zone', 'area', 'coverage area')
      COMMENT = 'Name of the geographic zone the unit covers',
    personnel.role_dim AS ROLE
      WITH SYNONYMS = ('job', 'position', 'title')
      COMMENT = 'Personnel role: CALLTAKER, DISPATCHER, FIREFIGHTER, PARAMEDIC, PATROL_OFFICER',
    personnel.shift_dim AS SHIFT
      WITH SYNONYMS = ('shift', 'tour', 'schedule')
      COMMENT = 'Work shift assignment: A, B, or C',
    personnel.person_status AS PERSON_STATUS
      WITH SYNONYMS = ('employee status')
      COMMENT = 'Personnel status: ACTIVE, INACTIVE, LEAVE',
    dispatches.dispatch_month AS MONTH(DISPATCH_TIMESTAMP)
      WITH SYNONYMS = ('month', 'period')
      COMMENT = 'Month of the dispatch event'
  )

  METRICS (
    units.total_units AS COUNT(UNIT_ID)
      WITH SYNONYMS = ('unit count', 'fleet size', 'resource count')
      COMMENT = 'Total number of response units',
    dispatches.total_dispatches AS COUNT(DISPATCH_ID)
      WITH SYNONYMS = ('dispatch count', 'deployment count', 'run count')
      COMMENT = 'Total number of dispatch events',
    dispatches.avg_response_time AS AVG(dispatches.response_time_fact)
      WITH SYNONYMS = ('average response time')
      COMMENT = 'Average response time in seconds',
    dispatches.avg_total_time AS AVG(dispatches.total_time_fact)
      WITH SYNONYMS = ('average busy time', 'avg total time')
      COMMENT = 'Average total busy time per dispatch in seconds',
    dispatches.avg_distance AS AVG(dispatches.distance_fact)
      WITH SYNONYMS = ('average distance', 'avg miles')
      COMMENT = 'Average distance traveled per dispatch in miles',
    personnel.total_personnel AS COUNT(PERSON_ID)
      WITH SYNONYMS = ('staff count', 'headcount', 'team size')
      COMMENT = 'Total number of personnel',
    personnel.avg_training_hours AS AVG(personnel.training_hours)
      WITH SYNONYMS = ('average training', 'training per person')
      COMMENT = 'Average training hours per person year-to-date',
    personnel.avg_qa_score AS AVG(personnel.qa_avg)
      WITH SYNONYMS = ('average quality score', 'team QA score')
      COMMENT = 'Average QA score across all personnel'
  )

  COMMENT = 'Semantic view for emergency response resource management including unit utilization, personnel metrics, and deployment analytics';
