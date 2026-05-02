---
name: "prepared911 agent build"
created: "2026-05-02T04:27:33.062Z"
status: pending
---

# Plan: Build Prepared911 Snowflake Intelligence Agent Project

## Overview

Build the complete Prepared911 Snowflake Intelligence Agent project per the template in `Prepared911-agent.md`. This includes 10 SQL/notebook files, documentation, and SVG architecture diagrams.

## Architecture

- **Database**: `PREPARED911_INTELLIGENCE`
- **Schemas**: `RAW` (raw tables), `ANALYTICS` (views/semantic views), `ONTOLOGY` (NIEM-based ontology)
- **Warehouse**: `PREPARED911_WH` (X-SMALL, auto-suspend 300s)
- **Agent**: `PREPARED911_AGENT` with Cortex Analyst, Cortex Search, and Custom Function tools

## Data Model (Tables in RAW schema)

1. **INCIDENT\_CALLS** — Core 911 call records (call\_id, timestamp, caller\_phone, location, lat/lon, call\_type, priority, language, duration, disposition)
2. **INCIDENTS** — Incident master records (incident\_id, call\_id, type\_code, severity, status, location, narrative, timestamps)
3. **RESPONSE\_UNITS** — Units dispatched (unit\_id, unit\_type, station, status, personnel\_count)
4. **UNIT\_DISPATCHES** — Dispatch assignments (dispatch\_id, incident\_id, unit\_id, dispatch\_time, enroute\_time, on\_scene\_time, clear\_time)
5. **PERSONNEL** — Staff records (person\_id, name, role, station, shift, certifications, hire\_date)
6. **CALL\_TRANSLATIONS** — Translation events (translation\_id, call\_id, source\_language, target\_language, method, duration)
7. **QA\_EVALUATIONS** — Quality assurance scores (eval\_id, call\_id, evaluator\_id, score, categories, feedback)
8. **PROTOCOLS** — Response protocols/SOPs (protocol\_id, name, category, description, steps, effective\_date)
9. **GEOGRAPHIC\_ZONES** — Geographic boundaries (zone\_id, name, type, population, area\_sq\_miles, risk\_level)

## Ontology Design (NIEM/NIMS-based)

- **ONTOLOGY\_CLASSES**: Emergency response domain classes (Incident, MedicalEmergency, FireEmergency, LawEnforcement, etc.)
- **ONTOLOGY\_PROPERTIES**: Class attributes and constraints
- **ONTOLOGY\_RELATIONSHIPS**: Class-to-class relationships (subClassOf, hasProtocol, requiresResource, etc.)
- **INCIDENT\_TYPE\_HIERARCHY**: MPDS/dispatch codes mapped to ontology classes
- **RESOURCE\_TYPE\_HIERARCHY**: NIMS resource typing
- **REGULATORY\_FRAMEWORKS**: NENA i3, NFPA, etc.

## Semantic Views (3 minimum)

1. **SV\_INCIDENT\_OPERATIONS** — Incident response metrics (response times, incident counts, severity distribution)
2. **SV\_CALL\_CENTER\_PERFORMANCE** — Call processing metrics (call volume, handle time, abandon rate, translation usage)
3. **SV\_RESOURCE\_MANAGEMENT** — Unit/personnel metrics (utilization, availability, deployment efficiency)

## Cortex Search Services (3 minimum)

1. **PROTOCOL\_SEARCH** — Search response protocols and SOPs by description/steps
2. **INCIDENT\_NARRATIVE\_SEARCH** — Search incident narratives for patterns and precedents
3. **TRAINING\_DOCUMENT\_SEARCH** — Search training materials and operational guidance

## ML Models (3 minimum)

1. **RESPONSE\_TIME\_PREDICTOR** — GradientBoostingRegressor to predict response time based on incident type, location, time of day, unit availability
2. **CALL\_PRIORITY\_CLASSIFIER** — RandomForestClassifier to classify call priority (1-5) from call attributes
3. **CALL\_VOLUME\_FORECASTER** — Time-series model to forecast hourly call volumes

## Agent Configuration

- **Tools**: 3 Cortex Analyst (semantic views), 3 Cortex Search, 3 Custom Functions (ML predictions + ontology resolver)
- **Instructions**: Emergency response domain expertise, natural language query routing
- **Sample questions**: 30+ complex questions covering all domains

## File Execution Order

1. `sql/setup/01_database_and_schema.sql`
2. `sql/setup/02_create_tables.sql`
3. `sql/data/03_Emergency_Response_Ontology.sql`
4. `sql/data/04_generate_synthetic_data.sql`
5. `sql/views/05_create_views.sql`
6. `sql/views/06_create_semantic_views.sql`
7. `sql/search/07_create_cortex_search.sql`
8. `notebooks/08_ml_models.ipynb`
9. `sql/models/09_ml_model_functions.sql`
10. `sql/agent/10_create_emergency_response_agent.sql`

## Documentation Deliverables

- `README.md` — Project overview with setup instructions
- `docs/AGENT_SETUP.md` — Step-by-step agent configuration
- `docs/DEPLOYMENT_SUMMARY.md` — Deployment status tracker
- `docs/questions.md` — 30+ test questions
- `docs/images/architecture.svg` — System architecture diagram
- `docs/images/deployment_flow.svg` — Deployment workflow
- `docs/images/ml_models.svg` — ML pipeline visualization

## Key Constraints

- All semantic views use TABLES/DIMENSIONS/METRICS syntax (NOT SELECT...FROM)
- All SQL UDFs use RETURNS ARRAY or RETURNS OBJECT (NOT VARIANT)
- Agent spec uses YAML format (NOT JSON)
- ML models MUST be registered in Model Registry and called via MODEL()!PREDICT()
- All documentation includes `<img src="Snowflake_Logo.svg" width="200">` header
- All graphics are SVG format
