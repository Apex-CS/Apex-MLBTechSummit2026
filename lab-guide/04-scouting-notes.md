# Module 4: Read the Scouting Notes

**Time:** 1:10 to 1:25 (15 minutes)
**Goal:** Use Cortex AI functions to turn free-text scouting reports into structured insights and compare them to the swing data.

## Context

Scouts write notes in plain English. They are rich with insight but hard to query at scale. In this module, you use Snowflake's built-in AI functions to extract structured fields from scouting notes, classify them by type, and then compare what the scouts see to what the numbers show.

## Steps

### Step 1: Extract structured fields with AI_EXTRACT

Give CoCo this prompt:

> Create a secure view called CORE.V_SCOUTING_EXTRACTED that uses AI_EXTRACT on RAW.STG_SCOUTING_NOTES.NOTE_TEXT to pull out four fields: SWING_ASSESSMENT (a brief summary of swing mechanics observations), DISCIPLINE_ASSESSMENT (plate discipline observations), INJURY_FLAG (true or false), and TREND_DIRECTION (improving, declining, or stable).

CoCo will write a query using `AI_EXTRACT` with a response format object. This uses Snowflake's `arctic-extract` model — no model selection is needed.

> **Checkpoint:** Run `SELECT NOTE_ID, SWING_ASSESSMENT, TREND_DIRECTION FROM CORE.V_SCOUTING_EXTRACTED LIMIT 5;` — you should see structured fields extracted from the free text. The first query may take 30-60 seconds as the AI function warms up.

### Step 2: Classify scouting notes with AI_CLASSIFY

Give CoCo this prompt:

> Create a secure view called CORE.V_SCOUTING_CLASSIFIED that builds on V_SCOUTING_EXTRACTED and uses AI_CLASSIFY to categorize each note as one of: mechanical_change, injury_concern, performance_trend, or general_observation. Call the new column NOTE_CATEGORY.

> **Checkpoint:** Run `SELECT NOTE_CATEGORY, COUNT(*) FROM CORE.V_SCOUTING_CLASSIFIED GROUP BY NOTE_CATEGORY;` — you should see notes distributed across the four categories.

### Step 3: Compare scouts to swing data

Give CoCo this prompt:

> Create a secure view called CORE.V_SCOUT_VS_DATA that joins the latest scouting note per hitter (from V_SCOUTING_CLASSIFIED) to the latest rolling stats per hitter (from V_HITTER_ROLLING_STATS). Compare the scout's TREND_DIRECTION to what the data shows: if the rolling bat speed is more than 1.5 mph below the season average call it 'declining', more than 1.5 above call it 'improving', otherwise 'stable'. Flag whether the scout and the data agree ('aligned'), disagree ('contradicts'), or partially differ ('partial gap'). Sort contradictions to the top.

> **Checkpoint:** Run `SELECT HITTER_NAME, DATA_TREND_DIRECTION, SCOUT_TREND_DIRECTION, ALIGNMENT_STATUS FROM CORE.V_SCOUT_VS_DATA WHERE HITTER_ID IN ('H-047', 'H-112', 'H-023');` — H-047 should be `aligned`: the scout and the bat speed numbers both say declining. H-112 and H-023 should be `partial gap`: the scouts saw something (a swing change, more chasing) that bat speed alone doesn't show. That's the case for joining narrative to data, and for checking more than one metric. Run `SELECT ALIGNMENT_STATUS, COUNT(*) FROM CORE.V_SCOUT_VS_DATA GROUP BY 1;` to see how often scouts and data disagree across the league.

## What you just built

You turned unstructured text into structured, queryable data using AI functions, then joined it to your metrics to surface narrative gaps. This is the "read the scouting report" capability — at scale, with no manual tagging.

Proceed to [Module 5: Ship the App](05-ship-the-app.md).
