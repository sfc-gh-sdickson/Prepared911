------------------------------------------------------------------------
-- Prepared911 Intelligence Agent
-- File: 07_create_cortex_search.sql
-- Purpose: Create Cortex Search services for RAG-based document search
------------------------------------------------------------------------

USE DATABASE PREPARED911_INTELLIGENCE;
USE SCHEMA ANALYTICS;
USE WAREHOUSE PREPARED911_WH;

------------------------------------------------------------------------
-- PROTOCOL_SEARCH: Search response protocols and SOPs
------------------------------------------------------------------------
CREATE OR REPLACE CORTEX SEARCH SERVICE PROTOCOL_SEARCH
  ON SEARCH_TEXT
  ATTRIBUTES CATEGORY, SUBCATEGORY, PRIORITY_LEVEL, STATUS
  WAREHOUSE = PREPARED911_WH
  TARGET_LAG = '1 hour'
  COMMENT = 'Search service for emergency response protocols and standard operating procedures'
AS (
  SELECT
    PROTOCOL_ID,
    PROTOCOL_NAME,
    CATEGORY,
    SUBCATEGORY,
    PRIORITY_LEVEL,
    STATUS,
    PROTOCOL_NAME || ': ' || DESCRIPTION || ' Steps: ' || COALESCE(STEPS, '') || ' Regulatory Reference: ' || COALESCE(REGULATORY_REF, '') AS SEARCH_TEXT
  FROM PREPARED911_INTELLIGENCE.RAW.PROTOCOLS
  WHERE STATUS = 'ACTIVE'
);

------------------------------------------------------------------------
-- INCIDENT_NARRATIVE_SEARCH: Search incident narratives
------------------------------------------------------------------------
CREATE OR REPLACE CORTEX SEARCH SERVICE INCIDENT_NARRATIVE_SEARCH
  ON SEARCH_TEXT
  ATTRIBUTES INCIDENT_TYPE_CODE, SEVERITY, ZONE_ID, STATUS
  WAREHOUSE = PREPARED911_WH
  TARGET_LAG = '1 hour'
  COMMENT = 'Search service for incident narratives to find patterns and precedents'
AS (
  SELECT
    INCIDENT_ID,
    INCIDENT_TYPE_CODE,
    INCIDENT_TYPE_NAME,
    SEVERITY,
    STATUS,
    ZONE_ID,
    INCIDENT_TYPE_NAME || ' - ' || SEVERITY || ' severity. ' || COALESCE(NARRATIVE, '') || ' Location: ' || COALESCE(LOCATION_ADDRESS, '') AS SEARCH_TEXT
  FROM PREPARED911_INTELLIGENCE.RAW.INCIDENTS
  WHERE NARRATIVE IS NOT NULL
);

------------------------------------------------------------------------
-- ONTOLOGY_KNOWLEDGE_SEARCH: Search ontology for domain concepts
------------------------------------------------------------------------
CREATE OR REPLACE CORTEX SEARCH SERVICE ONTOLOGY_KNOWLEDGE_SEARCH
  ON SEARCH_TEXT
  ATTRIBUTES DOMAIN, LEVEL, STANDARD_REF
  WAREHOUSE = PREPARED911_WH
  TARGET_LAG = '1 hour'
  COMMENT = 'Search service for emergency response ontology concepts, definitions, and regulatory frameworks'
AS (
  SELECT
    oc.CLASS_ID,
    oc.CLASS_NAME,
    oc.DOMAIN,
    oc.LEVEL,
    oc.STANDARD_REF,
    oc.CLASS_NAME || ': ' || COALESCE(oc.DESCRIPTION, '') ||
      COALESCE(' Parent: ' || pc.CLASS_NAME, '') ||
      COALESCE(' Standard: ' || oc.STANDARD_REF, '') AS SEARCH_TEXT
  FROM PREPARED911_INTELLIGENCE.ONTOLOGY.ONTOLOGY_CLASSES oc
  LEFT JOIN PREPARED911_INTELLIGENCE.ONTOLOGY.ONTOLOGY_CLASSES pc ON oc.PARENT_CLASS_ID = pc.CLASS_ID

  UNION ALL

  SELECT
    rf.FRAMEWORK_ID AS CLASS_ID,
    rf.FRAMEWORK_NAME AS CLASS_NAME,
    rf.DOMAIN,
    1 AS LEVEL,
    rf.VERSION AS STANDARD_REF,
    rf.FRAMEWORK_NAME || ' (' || rf.ORGANIZATION || '): ' || rf.DESCRIPTION || ' Requirements: ' || COALESCE(rf.KEY_REQUIREMENTS, '') AS SEARCH_TEXT
  FROM PREPARED911_INTELLIGENCE.ONTOLOGY.REGULATORY_FRAMEWORKS rf
);
