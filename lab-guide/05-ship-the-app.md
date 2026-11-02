# Module 5: Ship the Swing Doctor App

**Time:** 1:25 to 1:50 (25 minutes)
**Goal:** Use Cortex Code to build and deploy a Streamlit app with trend charts, alerts, and a plain-English question box.

## Context

Everything you have built so far — the trusted metrics, the alerts, the semantic layer, the scouting insights — is powerful but lives in SQL worksheets. In this module, you put it all together into an app that a hitting coach or scout can open in their browser and use without writing a single query.

## Steps

### Step 1: Ask CoCo to build the app

Give CoCo this prompt:

> Build me a Streamlit-in-Snowflake app called Swing Doctor. It should have:
>
> 1. A sidebar with dropdowns to filter by team and hitter (from RAW.STG_HITTERS), and a slider for the rolling window size in games (7 to 28, default 21).
> 2. A line chart showing the selected hitter's per-game bat speed and rolling average over time, with a horizontal line at their season average. Use Altair for the chart.
> 3. An alerts section with two columns: bat speed alerts from CORE.V_BAT_SPEED_ALERTS on the left, and chase rate alerts from CORE.V_CHASE_RATE_ANALYSIS on the right. Show each alert as an expandable card with the hitter name, team, and key numbers.
> 4. A text input at the bottom labeled "Ask Swing Doctor" where I can type a question in plain English. Use AI_COMPLETE with llama3.3-70b to generate SQL from the question, then run the SQL and show the results.
>
> Use my SWING_DOCTOR_&lt;nn&gt; database (replace &lt;nn&gt; with your user number). Connect with st.connection("snowflake"). Cast numeric aggregates such as AVG() to FLOAT in SQL so the chart axes show real values.

CoCo will generate a complete Python file. Review the code — it should have imports, a connection, sidebar filters, the chart, alert cards, and the question box.

> **Checkpoint:** Read through the generated code. It should have `st.set_page_config`, `st.connection("snowflake")`, sidebar filters with `st.selectbox` and `st.slider`, an Altair chart, `st.expander` for alerts, and `st.text_input` for the question box.

### Step 2: Deploy to Snowflake

Give CoCo this prompt:

> Deploy this app to Snowflake so I can open it in Snowsight. Put it in SWING_DOCTOR_&lt;nn&gt;.CORE, name it SWING_DOCTOR_APP, and title it 'Swing Doctor &lt;nn&gt;'. Run it on the container runtime using compute pool SYSTEM_COMPUTE_POOL_CPU, warehouse SWING_DOCTOR_WH, and package repository SNOWFLAKE.SNOWPARK.PYPI_SHARED_REPOSITORY. Create whatever files and objects the deployment needs, and finish the whole deployment yourself. When you are done, confirm the app exists and is ready to open.

CoCo handles the details: it creates a place to store the app files, writes the app and its package list, creates the app, and makes it live. You do not need to upload anything.

> **Checkpoint:** CoCo tells you the app is deployed. In Snowsight, go to **Projects** > **Streamlit** — you should see **SWING_DOCTOR_APP**. If it is not there, tell CoCo: "The app is not in Projects > Streamlit. Check what is missing and finish the deployment."

<details>
<summary>Still stuck? Facilitator fallback</summary>

Raise your hand, or run these steps yourself. In Snowsight go to **Data** > **Databases** > **SWING_DOCTOR_&lt;nn&gt;** > **CORE** > **Stages**, create or open **STREAMLIT_STAGE**, click **+ Files**, and upload the app file CoCo wrote (`swing_doctor.py`) plus `app/pyproject.toml` from the lab files. Then run:

```sql
CREATE STAGE IF NOT EXISTS CORE.STREAMLIT_STAGE;
LIST @CORE.STREAMLIT_STAGE;  -- should show swing_doctor.py and pyproject.toml

CREATE STREAMLIT IF NOT EXISTS CORE.SWING_DOCTOR_APP
    FROM '@CORE.STREAMLIT_STAGE'
    MAIN_FILE = 'swing_doctor.py'
    RUNTIME_NAME = 'SYSTEM$ST_CONTAINER_RUNTIME_PY3_11'
    COMPUTE_POOL = SYSTEM_COMPUTE_POOL_CPU
    QUERY_WAREHOUSE = 'SWING_DOCTOR_WH'
    ARTIFACT_REPOSITORIES = (SNOWFLAKE.SNOWPARK.PYPI_SHARED_REPOSITORY)
    TITLE = 'Swing Doctor <nn>'
    COMMENT = 'Swing Doctor — bat tracking early warning system';

ALTER STREAMLIT CORE.SWING_DOCTOR_APP ADD LIVE VERSION FROM LAST;
```
</details>
> The first launch takes 1–3 minutes while the container builds. If Snowsight shows "The selected compute pool is unable to start your app," wait a minute and refresh.

### Step 3: Open and test the app

1. In Snowsight, go to **Projects** > **Streamlit**
2. Find **SWING_DOCTOR_APP** and click to open it
3. Test the app:
   - Select different teams and hitters from the sidebar
   - Look at the bat speed trend chart — select **Remy Johnson** (H-047, DET) and watch the rolling average fade
   - Check the alerts section — Remy Johnson should appear in bat speed alerts, **Chris Wilson** (H-023, BOS) in chase rate alerts
   - Type a question in the "Ask Swing Doctor" box:
     - "Who changed their swing after the All-Star break?"
     - "Which team has the fastest average bat speed?"
     - "Show me H-112's monthly exit velocity"

> **Checkpoint:** The app loads, the chart renders, alerts appear, and the question box generates and runs SQL. If the question box returns an error, the LLM may have generated invalid SQL — try rephrasing.

### Step 4: Iterate (if time permits)

If you have extra time, ask CoCo to improve the app:

> Add a second tab that shows the scouting note analysis — a table of the latest scout assessment per hitter from CORE.V_SCOUT_VS_DATA, color-coded by alignment status.

Or:

> Add a metric card at the top showing total hitters monitored, total alerts, and the hitter with the biggest bat speed drop.

## What you just built

A working Streamlit app that a hitting coach can open in their browser to see trends, get alerts, and ask questions — all without writing SQL. The data pipeline, semantic layer, and AI functions you built in earlier modules power it under the hood.

## Wrap-up (1:50 - 2:00)

Congratulations. In two hours you went from raw CSV files to a deployed early warning system. Here is what you take home:

1. **A governed workspace pattern** — roles, data, and guardrails set once, reused by every analysis
2. **A semantic layer** — shared definitions so every question gets a consistent answer
3. **A working Swing Doctor app** — trend charts, alerts, and a question box you built yourself
4. **A repeatable Cortex Code workflow** — ask, plan, build, test, refine
5. **A request queue playbook** — which requests go self-serve, and which still need the data team

### Cleanup

No cleanup needed. Your lab user and its database are removed by the lab team after the event.
