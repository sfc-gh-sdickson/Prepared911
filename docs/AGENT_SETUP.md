<img src="Snowflake_Logo.svg" width="200">

# Prepared911 Agent Setup Guide

## Prerequisites

1. Snowflake account with ACCOUNTADMIN role access
2. Cortex AI features enabled in your region
3. Access to create databases, warehouses, and agents

## Step-by-Step Setup

### Step 1: Database and Schema Setup
```sql
-- Execute: sql/setup/01_database_and_schema.sql
-- Creates: PREPARED911_INTELLIGENCE database, RAW/ANALYTICS/ONTOLOGY schemas, PREPARED911_WH warehouse
```

### Step 2: Create Tables
```sql
-- Execute: sql/setup/02_create_tables.sql
-- Creates: 9 core tables (INCIDENT_CALLS, INCIDENTS, RESPONSE_UNITS, UNIT_DISPATCHES, PERSONNEL, CALL_TRANSLATIONS, QA_EVALUATIONS, PROTOCOLS, GEOGRAPHIC_ZONES)
```

### Step 3: Load Ontology
```sql
-- Execute: sql/data/03_Emergency_Response_Ontology.sql
-- Creates: NIEM/NIMS ontology tables with emergency response domain knowledge
```

### Step 4: Generate Synthetic Data
```sql
-- Execute: sql/data/04_generate_synthetic_data.sql
-- Loads: 5000 calls, 4000 incidents, 8000 dispatches, 600 translations, 3000 QA evaluations, 10 protocols
```

### Step 5: Create Analytical Views
```sql
-- Execute: sql/views/05_create_views.sql
-- Creates: 5 analytical views for reporting
```

### Step 6: Create Semantic Views
```sql
-- Execute: sql/views/06_create_semantic_views.sql
-- Creates: 3 semantic views (SV_INCIDENT_OPERATIONS, SV_CALL_CENTER_PERFORMANCE, SV_RESOURCE_MANAGEMENT)
```

### Step 7: Create Cortex Search Services
```sql
-- Execute: sql/search/07_create_cortex_search.sql
-- Creates: 3 search services (PROTOCOL_SEARCH, INCIDENT_NARRATIVE_SEARCH, ONTOLOGY_KNOWLEDGE_SEARCH)
```

### Step 8: Train and Register ML Models
```
-- Upload notebooks/08_ml_models.ipynb to Snowsight
-- Execute all cells in order
-- Registers: 3 models (RESPONSE_TIME_PREDICTOR, CALL_PRIORITY_CLASSIFIER, CALL_VOLUME_FORECASTER)
```

### Step 9: Create ML Model Functions
```sql
-- Execute: sql/models/09_ml_model_functions.sql
-- Creates: 5 UDFs for agent tool access
```

### Step 10: Create the Agent
```sql
-- Execute: sql/agent/10_create_emergency_response_agent.sql
-- Creates: PREPARED911_AGENT with 9 tools (3 Analyst, 3 Search, 3 Custom)
```

## Verification

After setup, test the agent with:
```sql
-- Verify agent exists
SHOW AGENTS LIKE 'PREPARED911_AGENT';

-- Test a semantic view
SELECT * FROM SEMANTIC_VIEW(
  SV_INCIDENT_OPERATIONS
  METRICS incidents.total_incidents
  DIMENSIONS incidents.incident_type
);
```

## Agent Tools Summary

| Tool | Type | Purpose |
|------|------|---------|
| IncidentOperationsAnalyst | Cortex Analyst | Response times, incident patterns |
| CallCenterAnalyst | Cortex Analyst | Call volumes, handle times, QA |
| ResourceManagementAnalyst | Cortex Analyst | Unit utilization, staffing |
| ProtocolSearch | Cortex Search | SOPs and protocols |
| IncidentNarrativeSearch | Cortex Search | Past incident examples |
| OntologySearch | Cortex Search | Domain concepts, standards |
| PredictResponseTime | Custom Function | ML response time prediction |
| ResolveOntology | Custom Function | Ontology concept resolution |
| GetZoneSummary | Custom Function | Zone operational summary |
