# Snowflake Intelligence Agent Project Template

## Purpose
Build an Snowflake Intelligence Agent that allows Investcloud customer to access their data and talk to their data.
## Customer details
About Investcloud
A Smarter Financial Future
At InvestCloud, we believe a smarter financial future starts with people. We exist to help wealth managers, advisors, and financial institutions create stronger connections with the clients they serve through technology that engages, inspires trust, and makes every interaction more meaningful.

We bring together the tools, intelligence, and infrastructure that power modern wealth management to help our clients better serve their own clients, both for today and for what’s next.

What
We Do
InvestCloud powers wealth management with offerings across the front, middle and back office. From client engagement to operations, private markets, and agentic tools, we help firms deliver better experiences, operate with greater intelligence, and unlock new opportunities for growth.

Managed Account Solutions
Managed
Account
Solutions
The largest managed account engine in the U.S., trusted at enterprise scale for trading, rebalancing, performance, and model delivery across millions of accounts and trillions in assets.

Altic™ Private Markets Network
Altic™
Private Markets
Network
A rules driven digital network for private markets, that is In-Good-Order by design. Built to support managed account volumes, millions of annual orders, at a near 0% NIGO rate.

Front Office Solutions
Front
Office
Solutions
A complete front office ecosystem that helps advisors deliver insightful advice, optimize efficiency, and earn deeper client trust, powered by connected data, intelligence, and client-focused design.

Data Management and Account Services
Data
Management
and Account
Services
Enterprise-grade data and account operations built to run faster, cleaner, and with stronger governance across your business.

Who We Serve
Financial Institutions
Modernize experiences and operations with enterprise-grade control and compliance.
Registered Investment Advisors (RIAs)
Grow without growing complexity, with connected tools that scale advice and service.
Asset Managers
Protect model integrity, reduce dispersion, and expand distribution with precision.
Turnkey Asset Management Platforms (TAMPs)
Power multi-custody managed accounts with white-label experiences advisors love.
Who We Serve
CULTURE AT WORK
mask-img-outer.svg
Our Values Are the Foundation of How We Innovate
mask-img-pattern.svg
At InvestCloud, our shared values guide how we build, how we partner, and how we earn trust every day.
These values are not slogans. They are the operating principles behind how we innovate, collaborate, and deliver results for clients, and how we build a culture that stays ahead.

Client Connected:
Our partnerships define us.
Human Centered:
People are at the core of everything we do.
Technology Forward:
We innovate with purpose.
Respect + Integrity:
Trust and accountability are central to how we work. Excellence:
We aspire to be the best in all we do.

We Believe the Future of Wealth Management Starts with People
At InvestCloud, we believe technology should do more than power platforms, it should help people build trust, strengthen relationships, and create better outcomes. That belief is why we exist and how we work every day. We partner closely with our clients, put people at the center of every experience, innovate with purpose, and lead with integrity and excellence so we can help shape a smarter future for wealth management.

Home  »  About Us  »  Why InvestCloud
Because When Hopes, Plans, and Peace of Mind Are on the Line, What We Build, and How We Build It, Matters
Because When Hopes, Plans, and Peace of Mind Are on the Line, What We Build, and How We Build It, Matters
That belief shapes everything we do at InvestCloud. It is why we partner closely with our clients, put people at the center of every experience, and pursue innovation with purpose. We know wealth management is not just about products or platforms. It is about helping people navigate important decisions with greater trust, clarity, and confidence. That is why we hold ourselves to a higher standard, leading with integrity, striving for excellence, and building technology that helps move wealth management forward in a more human way.

Innovation That Scales
Technology that Moves Wealth Management Forward
At InvestCloud, innovation is not just about what technology can do. It is about what it enables people to do better. We build with purpose, creating technology that helps firms serve clients with greater trust, clarity, and confidence, while moving wealth management forward in smarter, more thoughtful ways.

Integration
Bring together the data, systems, and workflows that help firms operate with greater clarity, consistency, and confidence.
Intelligence
Apply AI, analytics, and automation in ways that help teams move faster, make better decisions, and focus on higher-value work.
Personalization
Deliver connected, human-centered experiences at scale.
Connectivity
Support stronger collaboration across advisors, firms, and investors with technology that keeps people, information, and actions aligned.
Security
Build trust into every interaction with governance, transparency, and enterprise-grade protection designed to safeguard data and operations.
Scale
Enable firms to grow, adapt, and serve complexity with technology built for precision, resilience, and long-term performance.
Technology that Moves Wealth Management Forward
Move Wealth Management Forward
A Vision for the Future of Wealth
Move Wealth Management Forward
Discover how InvestCloud helps firms serve clients more thoughtfully, operate more intelligently, and grow with confidence in an evolving industry.

Culture at Work
Why InvestCloud

Client Connected
Our partnerships define us. Client Connected reflects our commitment to working together to solve real problems, create measurable value, and deliver innovative solutions that move the wealth management industry forward.
Human Centered
People are at the core of everything we do. Human Centered ensures that from the experiences we design to the way we collaborate, we put people first.
Technology Forward
We innovate with purpose. Technology Forward reflects our relentless pursuit of progress, combining deep industry expertise with modern engineering to solve complex challenges in smarter, more scalable ways.
Respect + Integrity
Trust and accountability are central to how we work. Through Respect + Integrity, we hold ourselves to the highest ethical standards, ensuring that honesty, fairness, and ownership guide every decision we make.
Excellence
We aspire to be the best in all we do. Excellence is our standard, driving us to deliver trusted quality and performance, and to continually raise the bar for our industry.
Proven Global Impact
WB-Swiss-Award-2025
WB-European-Award-2025
WB-Asia-Award-2025
MMI-Barrons-Award-2025
IC_Datos_Award_2025
$ 8 T
Assets On Systems

2.1 M
Trades Per Day
(90-Day Average)

40 M
Accounts

63 K
Advisors Served

4.5 M
Active Models

---

## Customer Configuration

**To create a new project, replace these variables throughout:**

| Variable | Description | Name |
|----------|-------------|-------------------|
| `{CUSTOMER_NAME}` | Customer name | Investcloud |
| `{CUSTOMER_NAME_UPPER}` | Uppercase for SQL objects | INVESTCLOUD |
| `{DATABASE_NAME}` | Main database name | INVESTCLOUD_INTELLIGENCE |
| `{WAREHOUSE_NAME}` | Warehouse name | INVESTCLOUD_WH |
| `{AGENT_NAME}` | Agent identifier | INVESTCLOUD_AGENT |
| `{BUSINESS_DOMAIN}` | Customer's business focus | Financial Investment Industries |
| `{WEB_PRESENCE}`  | Web Address | https://InvestCloud.com/

---

## Project Instructions

```Build a complete Snowflake Intelligence architecture and implementation plan for Investcloud.

The proposed architecture is a modern, streaming-first Scalable ELT Pipeline designed for near real-time data availability, scalability, and maintainability.  All of the financial data will stream data into Snowflake and they have the desire to be able to ask questions of their data with Natural Language Queries.

(Note: All project images should be SVG graphics)
 This Project should encompass all aspects of the details identified on their website. The Agent Project Structure directories should be created in the root github repo directory.
 ```
---

## Build the Ontology
```
Build a formal ontology, for Investment Banking, and integrate into the Snowflake Agentic Framework to provide a more exacting nature or structure to the platform.

The Snowflake agentic framework is architecturally ready to integrate a formal ontology today, even though it doesn't natively provide one. Here's how it could work for investment banking:

🏗️ How an Investment Banking Ontology Could Plug Into the Cortex Agent Framework
The Cortex Agent supports five tool types1, and a formal ontology could leverage several of them simultaneously:

1. Custom Tools — The Primary Integration Point
Use the investment banking ontology (e.g., FIBO — the Financial Industry Business Ontology) load into Snowflake tables you create representing classes, properties, and relationships. A stored procedure or UDF could then serve as the reasoning engine:

Agent receives: "What are our AML compliance exposures for correspondent banking relationships?"
Custom tool queries the ontology graph to resolve that "correspondent investment banking" is a subclass of "Wholesale Investment Banking," that AML is linked to BSA/OFAC/FinCEN regulations, and that "exposure" maps to specific risk metrics
This deterministic resolution then feeds precise parameters to the Semantic View query — no LLM guessing required
2. Cortex Search — Ontology as a Knowledge Base
The ontology's class definitions, relationship descriptions, and regulatory mappings could be indexed via Cortex Search, giving the agent a searchable reference for domain concepts it encounters in user questions.

3. Enriched Semantic Views — Ontology-Informed Descriptions
The semantic view definitions (metrics, dimensions, facts) could be annotated with ontology terms, making the tool descriptions more precise. Instead of:

"This table contains transaction data"

You have:

"This table contains payment transactions as defined by ISO 20022, linked to counterparty entities classified under FIBO's Financial Instrument Ontology"

🎯 What This Will Solve for Banking
Challenge Today (LLM-only)	With Formal Ontology
LLM guesses that "KYC" relates to customer onboarding	Ontology knows KYC → CDD/EDD → BSA requirements → specific data elements
Agent probabilistically routes to the right tool	Ontology provides deterministic concept resolution before routing
Ambiguous terms get inconsistent treatment	Formal definitions ensure "exposure" always means the same thing
Regulatory hierarchies are implicit	Explicit: Basel III → Pillar 1 → Credit Risk → IRB Approach → specific metrics
Cross-domain questions break down	Ontology formally links Risk ↔ Compliance ↔ Finance ↔ Operations
🔧 A Practical Architecture Pattern
User Question
    ↓
Cortex Agent (Orchestrator)
    ↓
┌─────────────────────────────────────────────┐
│  Step 1: Ontology Resolution (Custom Tool)  │
│  - Resolve domain concepts                  │
│  - Identify regulatory frameworks           │
│  - Map to specific data entities            │
│  - Return structured context to agent       │
├─────────────────────────────────────────────┤
│  Step 2: Informed Data Retrieval            │
│  - Cortex Analyst + Semantic Views          │
│    (now with precise ontology context)      │
│  - Cortex Search (regulatory documents)     │
├─────────────────────────────────────────────┤
│  Step 3: Validated Response                 │
│  - Agent composes answer with ontology-     │
│    grounded terminology and relationships   │
└─────────────────────────────────────────────┘
The key insight: the ontology acts as a deterministic pre-processing layer that constrains and informs the LLM's probabilistic reasoning — giving you the precision of formal logic with the flexibility of natural language interaction.

```
---

## Agent Project Structure

```
/
├── README.md                           # Project overview and setup instructions
├── docs/
│   ├── AGENT_SETUP.md                 # Step-by-step agent configuration guide
│   ├── DEPLOYMENT_SUMMARY.md          # Current deployment status
│   ├── questions.md                   # 30+ complex test questions
│   └── images/
│       ├── architecture.svg           # System architecture diagram
│       ├── deployment_flow.svg        # Deployment workflow diagram
│       └── ml_models.svg              # ML pipeline visualization
├── notebooks/
│   └── 08_ml_models.ipynb      # ML model training (optional)
└── sql/
    ├── setup/
    │   ├── 01_database_and_schema.sql # Database, schemas, warehouse
    │   └── 02_create_tables.sql       # All table definitions
    |   └── 03_Financial_Industry_Business_Ontology.sql # Create all tables and load the FIBO Ontology
    ├── data/
    │   └── 04_generate_synthetic_data.sql # Test data generation
    ├── views/
    │   ├── 05_create_views.sql        # Analytical views
    │   └── 06_create_semantic_views.sql # Semantic views for Cortex Analyst
    ├── search/
    │   └── 07_create_cortex_search.sql # Cortex Search services
    ├── models/
    │   └── 09_ml_model_functions.sql  # ML prediction views and agent functions
    └── agent/
        └── 10_create_financial_agent.sql # Agent creation script
```

---

## File Execution Order

**MUST be executed in this exact order:**

These are examples of what is required.  You may need to add more project defined project.  The documentation should have an SVG image showing the project flow.

1. `sql/setup/01_database_and_schema.sql`
2. `sql/setup/02_create_tables.sql`
3. `sql/data/03_Financial_Industry_Business_Ontology.sql`
4. `sql/data/04_generate_synthetic_data.sql`
5. `sql/views/05_create_views.sql`
6. `sql/views/06_create_semantic_views.sql`
7. `sql/search/07_create_cortex_search.sql`
8. `notebooks/08_ml_models.ipynb`
9. `sql/models/09_ml_model_functions.sql`
10. `sql/agent/10_create_agent.sql`

---

## Critical Syntax Reference

### Snowflake Agent YAML Specification (VERIFIED WORKING)

```yaml
CREATE OR REPLACE AGENT {AGENT_NAME}
  COMMENT = '{Customer} intelligence agent'
  PROFILE = '{"display_name": "{Customer} Assistant", "color": "blue"}'
  FROM SPECIFICATION
  $$
  models:
    orchestration: auto

  orchestration:
    budget:
      seconds: 60
      tokens: 32000

  instructions:
    response: "Response instructions..."
    orchestration: "Tool routing instructions..."
    system: "System role description..."
    sample_questions:
      - question: "Sample question?"
        answer: "How the agent should respond."

  tools:
    # Cortex Analyst (text-to-SQL)
    - tool_spec:
        type: "cortex_analyst_text_to_sql"
        name: "ToolName"
        description: "Description of what this tool does"

    # Cortex Search
    - tool_spec:
        type: "cortex_search"
        name: "SearchName"
        description: "Description of search capability"

    # Custom Function (generic)
    - tool_spec:
        type: "generic"
        name: "FunctionName"
        description: "Description of function output"

  tool_resources:
    # Cortex Analyst resource
    ToolName:
      semantic_view: "{DATABASE}.{SCHEMA}.{SEMANTIC_VIEW_NAME}"

    # Cortex Search resource
    SearchName:
      name: "{DATABASE}.{SCHEMA}.{SEARCH_SERVICE_NAME}"
      max_results: "10"
      title_column: "column_name"
      id_column: "id_column"

    # Custom Function resource
    FunctionName:
      type: "function"
      identifier: "{DATABASE}.{SCHEMA}.{FUNCTION_NAME}"
      execution_environment:
        type: "warehouse"
        warehouse: "{WAREHOUSE_NAME}"
  $$;
```

### SQL UDF Return Types (VERIFIED)

| Function Returns | Correct Return Type |
|------------------|---------------------|
| `ARRAY_AGG(...)` | `RETURNS ARRAY` |
| `OBJECT_CONSTRUCT(...)` | `RETURNS OBJECT` |
| Single scalar value | `RETURNS VARCHAR/NUMBER/etc` |

**DO NOT USE:**
- `RETURNS VARIANT` for `ARRAY_AGG` or `OBJECT_CONSTRUCT`
- `LANGUAGE SQL` clause in SQL UDFs

### SQL UDF Syntax (VERIFIED)

```sql
-- Correct syntax for scalar UDF returning ARRAY
CREATE OR REPLACE FUNCTION AGENT_GET_DATA()
RETURNS ARRAY
AS
$$
SELECT ARRAY_AGG(OBJECT_CONSTRUCT(
    'key1', COLUMN1,
    'key2', COLUMN2
)) FROM (SELECT * FROM TABLE LIMIT 50)
$$;

-- Correct syntax for scalar UDF returning OBJECT
CREATE OR REPLACE FUNCTION AGENT_GET_SUMMARY()
RETURNS OBJECT
AS
$$
SELECT OBJECT_CONSTRUCT(
    'metric1', (SELECT COUNT(*) FROM TABLE1),
    'metric2', (SELECT AVG(COLUMN) FROM TABLE2)
)
$$;
```

---

## Lessons Learned (CRITICAL)

### 1. ALWAYS VERIFY SNOWFLAKE SYNTAX BEFORE WRITING CODE

**What went wrong:** Multiple syntax errors because I guessed at syntax instead of verifying against Snowflake documentation.

**Correct approach:**
- Use `snowflake_product_docs` tool to look up syntax BEFORE writing any SQL
- Use `system_instructions` tool for Cortex Agent, Analyst, and other Snowflake products
- Reference working examples

**Specific errors made:**
- Used `RETURNS VARIANT` instead of `RETURNS ARRAY` for `ARRAY_AGG`
- Used `RETURNS VARIANT` instead of `RETURNS OBJECT` for `OBJECT_CONSTRUCT`
- Used `LANGUAGE SQL` clause which is invalid for SQL UDFs
- Used `type: "procedure"` instead of `type: "function"` for agent tools
- Used `search_service:` instead of `name:` for Cortex Search resources
- Used JSON format instead of YAML for agent specification

### 2. COMPLETE ALL FILES BEFORE STOPPING

**What went wrong:** Generated partial files and stopped without completing the project, leaving merge conflicts and incomplete code.

**Correct approach:**
- Review ALL files in the project at the start
- Create a TODO list for every file that needs to be created/modified
- Do not mark a task complete until the file is verified to compile/run
- Verify file completeness before moving to the next task

### 3. NEVER GUESS - ASK OR RESEARCH

**What went wrong:** Made assumptions about:
- Agent YAML syntax
- SQL UDF return types
- Function naming conventions
- Tool resource configuration

**Correct approach:**
- If unsure about syntax, use documentation tools first
- If documentation is unclear, ask the user for clarification
- Reference working examples from similar projects
- Test small pieces of code before combining them

### 4. ASK QUESTIONS WHEN UNCLEAR

**What went wrong:** Proceeded with assumptions instead of asking for clarification on requirements.

**Questions to ask upfront:**
- What business domain/industry is this for?
- What specific ML models or predictions are needed?
- What data sources exist or need to be created?
- What sample questions should the agent answer?
- Are there any existing working examples to reference?

### 5. SEMANTIC VIEWS USE TABLES/DIMENSIONS/METRICS — NOT SELECT...FROM

**What went wrong:** Used regular view syntax (`SELECT ... FROM`) for `CREATE SEMANTIC VIEW`, causing compilation errors (`unexpected 'COMMENT'`, `unexpected 'AS'`).

**Correct approach:**
- Semantic views use `TABLES (...)`, `DIMENSIONS (...)`, and `METRICS (...)` clauses
- They do NOT use `SELECT ... FROM` like regular views
- Each table is declared with `alias AS fully.qualified.table PRIMARY KEY (...)`
- Dimensions are categorical/descriptive columns: `alias.col AS COL_NAME`
- Metrics are numeric/aggregatable columns: `alias.col AS AGG_FUNC(COL_NAME)`
- Synonyms on columns use `WITH SYNONYMS = (...)` (with `=`), on tables use `WITH SYNONYMS (...)` (no `=`)
- ALWAYS use `snowflake_product_docs` to look up `CREATE SEMANTIC VIEW` syntax before writing

### 6. SNOWFLAKE NOTEBOOKS — SESSION AND SQL CELL RULES

**What went wrong:** Wrote Snowflake Notebooks using wrong session management and SQL patterns:
- Used `Session.builder.configs(...).create()` to create sessions (fails in Snowflake Notebooks)
- Used `session.sql("...").to_pandas()` for data queries instead of dedicated SQL cells

**Correct approach:**
- **Session:** ALWAYS use `get_active_session()` — NEVER use `Session.builder`:
  ```python
  from snowflake.snowpark.context import get_active_session
  session = get_active_session()
  ```
- **SQL queries:** ALWAYS use dedicated SQL cells (cell_type: "sql") with `result_variable_name` — NEVER use `session.sql()`
- SQL cell results are automatically available as pandas DataFrames in subsequent Python cells via the `result_variable_name`
- Do NOT call `.to_pandas()` on SQL cell results — they are already DataFrames
- Use `session` only when Snowpark DataFrame operations are genuinely needed (e.g., writing to tables, ML model registry)
- ALWAYS call `get_notebook_guide` before writing any notebook code

**Snowflake Notebook cell pattern:**
```
# SQL cell (cell_type: "sql", result_variable_name: "df_telemetry")
SELECT * FROM BD_INTELLIGENCE.RAW.ROBOT_TELEMETRY

# Python cell — reference SQL result directly as pandas DataFrame
print(f'Rows: {len(df_telemetry)}')
```

### 8. ML MODELS MUST BE REGISTERED IN MODEL REGISTRY AND CALLED BY UDFs — NO EXCEPTIONS

**What went wrong:** Trained 3 ML models in the notebook (RandomForestClassifier, Z-score anomaly detection, GradientBoostingRegressor) but NEVER registered them in the Snowflake Model Registry. The SQL UDFs in file 08 used hardcoded thresholds (e.g., `MOTOR_TEMPERATURE_C > 85`, `VIBRATION_MM_S > 10`, `EXPECTED_LIFESPAN_DAYS - DAYS_SINCE_INSTALL`) instead of calling the trained models. This made the ML models completely disconnected — they existed only in the notebook and were never used by the agent. This is unacceptable and defeats the entire purpose of training ML models.

**Correct approach — MANDATORY for every project:**
1. **Notebook MUST register models** using `snowflake.ml.registry.Registry`:
   ```python
   from snowflake.ml.registry import Registry
   registry = Registry(session=session, database_name="DB", schema_name="SCHEMA")
   mv = registry.log_model(
       trained_model,
       model_name="MODEL_NAME",
       version_name="V1",
       sample_input_data=X_train,
       conda_dependencies=["scikit-learn"],
       comment="Model description"
   )
   mv.set_metric("accuracy", score)
   ```

2. **SQL UDFs MUST call registered models** using `MODEL(name, version)!PREDICT(...)`:
   ```sql
   SELECT MODEL(DB.SCHEMA.MODEL_NAME, V1)!PREDICT(col1, col2, ...):output_feature_0::INT
   FROM table;
   ```

3. **NEVER use hardcoded thresholds** as a substitute for ML model predictions in UDFs. If a model was trained, it MUST be registered and called.

4. **Verify the full pipeline** before marking complete: Notebook trains → Notebook registers → UDFs call registered models → Agent invokes UDFs.

**Checklist (MUST complete for every ML model):**
- [ ] Model trained in notebook
- [ ] Model registered via `registry.log_model()`
- [ ] Metrics tracked via `mv.set_metric()`
- [ ] SQL UDF calls model via `MODEL(name, version)!PREDICT(...)`
- [ ] Agent tool references UDF
- [ ] End-to-end pipeline verified

### 7. VERIFY GIT MERGE CONFLICTS

**What went wrong:** Left merge conflict markers (`<<<<<<<`, `=======`, `>>>>>>>`) in SQL files.

**Correct approach:**
- After any file operations, verify no merge conflicts exist
- Search for conflict markers before marking files complete
- Test SQL files compile before considering them done

---

## Component Templates

### Database Setup (01_database_and_schema.sql)

```sql
CREATE DATABASE IF NOT EXISTS {DATABASE_NAME};
USE DATABASE {DATABASE_NAME};

CREATE SCHEMA IF NOT EXISTS RAW;
CREATE SCHEMA IF NOT EXISTS ANALYTICS;

CREATE OR REPLACE WAREHOUSE {WAREHOUSE_NAME} WITH
    WAREHOUSE_SIZE = 'X-SMALL'
    AUTO_SUSPEND = 300
    AUTO_RESUME = TRUE
    INITIALLY_SUSPENDED = TRUE
    COMMENT = 'Warehouse for {CUSTOMER_NAME} Intelligence Agent';

USE WAREHOUSE {WAREHOUSE_NAME};
```

### Cortex Search Service

```sql
CREATE OR REPLACE CORTEX SEARCH SERVICE {SEARCH_SERVICE_NAME}
  ON {text_column}
  ATTRIBUTES {attr1}, {attr2}, {attr3}
  WAREHOUSE = {WAREHOUSE_NAME}
  TARGET_LAG = '1 hour'
  COMMENT = 'Description of search service'
AS
  SELECT
    {columns}
  FROM {TABLE};
```

### Semantic View

```sql
CREATE OR REPLACE SEMANTIC VIEW {SEMANTIC_VIEW_NAME}

  TABLES (
    {alias} AS {database}.{schema}.{table}
      PRIMARY KEY ({primary_key_column})
      WITH SYNONYMS ('{synonym1}', '{synonym2}')
      COMMENT = '{Table description}'
  )

  DIMENSIONS (
    {alias}.{column} AS {COLUMN_NAME}
      WITH SYNONYMS = ('{synonym1}', '{synonym2}')
      COMMENT = '{Column description}'
  )

  METRICS (
    {alias}.{column} AS {AGG_FUNC}({COLUMN_NAME})
      WITH SYNONYMS = ('{synonym1}', '{synonym2}')
      COMMENT = '{Metric description}'
  )

  COMMENT = '{Semantic view description}';
```

**IMPORTANT: Semantic views do NOT use SELECT...FROM syntax. They use TABLES, DIMENSIONS, and METRICS clauses.**

### Snowflake Notebook (07_ml_models.ipynb)

```python
# Cell 1 (Python): Session setup — ONLY way to get session in Snowflake Notebooks
from snowflake.snowpark.context import get_active_session
session = get_active_session()
```

```sql
-- Cell 2 (SQL, result_variable_name: "df_data"): Load data via SQL cell — NOT session.sql()
SELECT * FROM {DATABASE}.{SCHEMA}.{TABLE}
```

```python
# Cell 3 (Python): Use SQL cell result directly as pandas DataFrame
# df_data is already a pandas DataFrame — do NOT call .to_pandas()
print(f'Rows: {len(df_data)}')
```

**IMPORTANT: NEVER use `Session.builder` or `session.sql()` in Snowflake Notebooks. Use `get_active_session()` and dedicated SQL cells.**

---

## Checklist for New Projects

### Before Starting
- [ ] Confirm customer name and business domain
- [ ] Identify data sources (existing tables or need synthetic data)
- [ ] Determine ML models needed (LTV, churn, risk, etc.)
- [ ] Collect sample questions the agent should answer
- [ ] Get working example project for reference

### During Development
- [ ] Verify ALL SQL syntax against Snowflake docs before writing
- [ ] Test each SQL file compiles before moving to next
- [ ] Check for merge conflicts after any file operations
- [ ] Complete TODO list for every component

### Before Delivery
- [ ] Run all SQL files in order (01-08)
- [ ] Test agent creation succeeds
- [ ] Verify agent responds to sample questions
- [ ] Update documentation with customer-specific details
- [ ] Remove any placeholder values

---

## Reference Links

- Snowflake Agent Docs: `snowflake_product_docs` → "Cortex Agent"
- SQL UDF Reference: `snowflake_product_docs` → "CREATE FUNCTION SQL"
- Cortex Search: `snowflake_product_docs` → "CREATE CORTEX SEARCH SERVICE"
- Semantic Views: `snowflake_product_docs` → "CREATE SEMANTIC VIEW"

---

## Version History

- **v1.1** - Initial template based on previous Intelligence Agent project
- **Created:** May 2026
- **Lessons Learned:** Documented from previous project issues

---

## DO NOT:
1. Guess at syntax - VERIFY FIRST
2. Use `RETURNS VARIANT` for `ARRAY_AGG` or `OBJECT_CONSTRUCT`
3. Use `LANGUAGE SQL` in SQL UDFs
4. Use JSON format for Agent specification (use YAML)
5. Leave merge conflicts in files
6. Mark tasks complete before verifying they work
7. Assume you know Snowflake syntax without checking
8. Use text based graphics
9. Use `SELECT ... FROM` syntax in `CREATE SEMANTIC VIEW` — use `TABLES`, `DIMENSIONS`, `METRICS` instead
10. Use `Session.builder.configs(...).create()` in Snowflake Notebooks — use `get_active_session()` instead
11. Use `session.sql()` in Snowflake Notebooks for standard queries — use dedicated SQL cells instead
12. Call `.to_pandas()` on SQL cell results in notebooks — they are already pandas DataFrames
13. Train ML models without registering them in the Snowflake Model Registry
14. Use hardcoded thresholds in SQL UDFs when a trained ML model exists — ALWAYS use `MODEL(name, version)!PREDICT()`
15. Mark ML model tasks complete without verifying the full pipeline: train → register → UDF calls model → agent invokes UDF

## DO:
1. Use `snowflake_product_docs` before writing SQL
2. Use `system_instructions` for Cortex products
3. Reference working examples
4. Ask questions when requirements are unclear
5. Test each file compiles before moving on
6. Complete ALL files before stopping
7. Verify no merge conflicts exist
8. Always generate documentation
9. Always generate SVG images for the documentation.
10. Always generate all files and never placeholders
11. Always put this line of code at the top of all documentation files: <img src="Snowflake_Logo.svg" width="200">
12. In Snowflake Notebooks, ALWAYS use `get_active_session()` for session and dedicated SQL cells for queries
13. ALWAYS call `get_notebook_guide` before writing any notebook code
14. ALWAYS create at least 3 Semantic Views, 3 Cortex Searches, and 3 ML Models
15. If an Ontology is included, always create an SVG diagram that shows the agent tool execution path
