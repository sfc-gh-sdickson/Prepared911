------------------------------------------------------------------------
-- Prepared911 Intelligence Agent
-- File: 10_create_emergency_response_agent.sql
-- Purpose: Create the Prepared911 Cortex Agent
------------------------------------------------------------------------

USE DATABASE PREPARED911_INTELLIGENCE;
USE SCHEMA ANALYTICS;
USE WAREHOUSE PREPARED911_WH;

CREATE OR REPLACE AGENT PREPARED911_AGENT
  COMMENT = 'Prepared911 emergency response intelligence agent'
  PROFILE = '{"display_name": "Prepared911 Assistant", "color": "red"}'
  FROM SPECIFICATION
  $$
  models:
    orchestration: auto

  orchestration:
    budget:
      seconds: 60
      tokens: 32000

  instructions:
    response: "You are an AI assistant for emergency response operations. Provide clear, actionable answers about 911 call center performance, incident response metrics, resource management, and emergency protocols. Always include relevant metrics with units (seconds for time, miles for distance). When discussing response times, reference NFPA standards. Format numbers for readability."
    orchestration: "Route questions about incident data, response times, and operational metrics to the semantic view tools. Route questions about protocols, SOPs, and regulatory standards to the search tools. Route prediction questions to the ML function tools. Use the ontology resolver for domain concept clarification."
    system: "You are the Prepared911 Intelligence Agent, an AI-powered assistant for 911 centers and emergency response agencies. You help dispatchers, supervisors, and administrators understand their operational data, find relevant protocols, predict response outcomes, and optimize resource deployment. You have access to incident records, call center metrics, response unit data, quality assurance scores, translation analytics, and emergency response protocols."
    sample_questions:
      - question: "What is the average response time for cardiac emergencies in the Downtown Core?"
        answer: "I would query the incident operations semantic view filtering by incident type MED-CARDIAC and zone Downtown Core to calculate the average response time in seconds, then compare it to the NFPA target of 360 seconds."
      - question: "How many calls required translation services last month?"
        answer: "I would query the call center performance semantic view to count calls where translation was needed in the past month, broken down by language."
      - question: "What protocol applies to a structure fire?"
        answer: "I would search the protocol knowledge base for structure fire response procedures and return the relevant SOP with step-by-step instructions."
      - question: "Predict the response time for a medical emergency in Zone 5 at 3 AM"
        answer: "I would use the response time prediction model with inputs: medical emergency type, Zone-05, hour 3, and return the predicted seconds along with the NFPA target."

  tools:
    - tool_spec:
        type: "cortex_analyst_text_to_sql"
        name: "IncidentOperationsAnalyst"
        description: "Query incident response data including response times, dispatch counts, incident types, severity levels, geographic zones, and unit deployment metrics. Use for questions about how fast units respond, incident volumes, and operational performance."

    - tool_spec:
        type: "cortex_analyst_text_to_sql"
        name: "CallCenterAnalyst"
        description: "Query call center performance data including call volumes, handle times, translation usage, quality scores, language breakdown, and call sources. Use for questions about call processing efficiency, multilingual support, and QA metrics."

    - tool_spec:
        type: "cortex_analyst_text_to_sql"
        name: "ResourceManagementAnalyst"
        description: "Query resource and personnel data including unit utilization, fleet status, staffing levels, training hours, and deployment patterns. Use for questions about resource availability, personnel performance, and capacity planning."

    - tool_spec:
        type: "cortex_search"
        name: "ProtocolSearch"
        description: "Search emergency response protocols, standard operating procedures, and regulatory guidelines. Use for questions about how to handle specific incident types, what steps to follow, or what regulations apply."

    - tool_spec:
        type: "cortex_search"
        name: "IncidentNarrativeSearch"
        description: "Search past incident narratives to find similar events, patterns, and precedents. Use when looking for examples of how specific situations were handled."

    - tool_spec:
        type: "cortex_search"
        name: "OntologySearch"
        description: "Search the emergency response ontology for domain concept definitions, regulatory frameworks, resource typing, and incident classification hierarchies."

    - tool_spec:
        type: "generic"
        name: "PredictResponseTime"
        description: "Predict the expected response time for an incident given its type, severity, zone, and time factors. Returns predicted seconds and NFPA target comparison."

    - tool_spec:
        type: "generic"
        name: "ResolveOntology"
        description: "Resolve emergency response domain concepts using the formal NIEM/NIMS ontology. Returns class definitions, related resources, applicable protocols, and regulatory context for any emergency response term."

    - tool_spec:
        type: "generic"
        name: "GetZoneSummary"
        description: "Get a comprehensive summary of a geographic response zone including demographics, risk level, assigned units, recent incident count, and average response time."

  tool_resources:
    IncidentOperationsAnalyst:
      semantic_view: "PREPARED911_INTELLIGENCE.ANALYTICS.SV_INCIDENT_OPERATIONS"

    CallCenterAnalyst:
      semantic_view: "PREPARED911_INTELLIGENCE.ANALYTICS.SV_CALL_CENTER_PERFORMANCE"

    ResourceManagementAnalyst:
      semantic_view: "PREPARED911_INTELLIGENCE.ANALYTICS.SV_RESOURCE_MANAGEMENT"

    ProtocolSearch:
      name: "PREPARED911_INTELLIGENCE.ANALYTICS.PROTOCOL_SEARCH"
      max_results: "5"
      title_column: "PROTOCOL_NAME"
      id_column: "PROTOCOL_ID"

    IncidentNarrativeSearch:
      name: "PREPARED911_INTELLIGENCE.ANALYTICS.INCIDENT_NARRATIVE_SEARCH"
      max_results: "10"
      title_column: "INCIDENT_TYPE_NAME"
      id_column: "INCIDENT_ID"

    OntologySearch:
      name: "PREPARED911_INTELLIGENCE.ANALYTICS.ONTOLOGY_KNOWLEDGE_SEARCH"
      max_results: "5"
      title_column: "CLASS_NAME"
      id_column: "CLASS_ID"

    PredictResponseTime:
      type: "function"
      identifier: "PREPARED911_INTELLIGENCE.ANALYTICS.AGENT_PREDICT_RESPONSE_TIME"
      execution_environment:
        type: "warehouse"
        warehouse: "PREPARED911_WH"

    ResolveOntology:
      type: "function"
      identifier: "PREPARED911_INTELLIGENCE.ANALYTICS.AGENT_RESOLVE_ONTOLOGY"
      execution_environment:
        type: "warehouse"
        warehouse: "PREPARED911_WH"

    GetZoneSummary:
      type: "function"
      identifier: "PREPARED911_INTELLIGENCE.ANALYTICS.AGENT_GET_ZONE_SUMMARY"
      execution_environment:
        type: "warehouse"
        warehouse: "PREPARED911_WH"
  $$;
