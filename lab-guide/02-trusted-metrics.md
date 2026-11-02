# Module 2: From Raw Swings to Trusted Metrics

**Time:** 0:25 to 0:50 (25 minutes)
**Goal:** Use Cortex Code to clean the raw data, discover planted quality issues, and build analytical views.

## Context

The raw swing data has problems — just like real data does. In this module, Cortex Code will help you profile the data, find the issues, clean them up, and build the trusted views that everything else depends on. You will give CoCo prompts in plain English and it will write and run the SQL.

## Steps

### Step 1: Open Cortex Code

In Snowsight, open **Cortex Code** (the AI assistant panel). Make sure your session is set to (replace `<nn>` with the number in your username, e.g. `USER07` → `07`):
- **Role:** `USER<nn>_ROLE`
- **Database:** `SWING_DOCTOR_<nn>`
- **Warehouse:** `SWING_DOCTOR_WH`

### Step 2: Profile the raw swing data

Give CoCo this prompt:

> Profile the RAW.STG_SWINGS table. Show me the total row count, count of distinct SWING_IDs, and the null rate for every column. Are there any data quality issues?

**What you should discover:**
- ~200 duplicate rows (total rows > distinct SWING_IDs)
- ~50 rows with NULL BAT_SPEED (a sensor outage on 3 game dates)
- NULL EXIT_VELOCITY and LAUNCH_ANGLE are expected on whiffs — that is not a problem

> **Checkpoint:** You found duplicates and null bat speeds. If CoCo's query does not reveal them, try asking: "How many duplicate SWING_IDs are there in STG_SWINGS?"

### Step 3: Clean and model the swing data

Give CoCo this prompt:

> Create a secure view called CORE.V_SWING_METRICS that deduplicates STG_SWINGS on SWING_ID keeping the first occurrence, filters out rows where BAT_SPEED is null, joins to STG_GAMES to add GAME_DT and GAME_NUM, and adds a CONTACT_QUALITY_CD column: 'whiff' when CONTACT_OUTCOME_CD = 'whiff', 'foul' when CONTACT_OUTCOME_CD = 'foul', and for balls in play 'barrel' when EXIT_VELOCITY >= 98 AND LAUNCH_ANGLE BETWEEN 26 AND 30, 'hard_hit' when EXIT_VELOCITY >= 95, 'medium' when EXIT_VELOCITY >= 80, otherwise 'soft'. Also add an IS_CHASE_FLAG that is TRUE when PITCH_ZONE_CD >= 10.

CoCo will write a `CREATE OR REPLACE SECURE VIEW` statement with a CTE for deduplication and a CASE expression for contact quality.

> **Why fouls get their own bucket:** fouls carry exit velocity and launch angle in this data, but contact quality (barrel, hard-hit) is a batted-ball measure, so it is graded on balls in play only.
>
> **Simplifications (synthetic data):** the barrel rule here is a fixed 98+ mph at 26-30 degrees; real Statcast barrels widen the launch-angle window as exit velocity rises. Zones 1-9 are the strike zone and 10-14 are out of zone; Statcast numbers its out-of-zone areas 11-14.

> **Checkpoint:** Run `SELECT COUNT(*) FROM CORE.V_SWING_METRICS;` — you should see fewer rows than STG_SWINGS (duplicates and nulls removed).

### Step 4: Build rolling averages

Give CoCo this prompt:

> Create a secure view called CORE.V_HITTER_ROLLING_STATS with one row per hitter per game. Calculate 21-game rolling averages (the current game plus the 20 before it) for BAT_SPEED, ATTACK_ANGLE, EXIT_VELOCITY on balls in play only (CONTACT_OUTCOME_CD = 'in_play'), and CHASE_RATE. Compute chase rate per game from RAW.STG_PITCHES as swings at out-of-zone pitches (PITCH_ZONE_CD 10 through 14 and IS_SWING_FLAG) divided by all out-of-zone pitches seen, then average it over the window. Add the hitter's season average for each metric as a comparison column. Join to STG_HITTERS to include HITTER_NAME and TEAM_CD.

> **Why STG_PITCHES:** chase rate is how often a hitter swings at pitches *outside* the zone. That needs the pitches he took, too, and STG_SWINGS only has swings. STG_PITCHES has every pitch seen.

> **Checkpoint:** Run `SELECT * FROM CORE.V_HITTER_ROLLING_STATS WHERE HITTER_ID = 'H-047' ORDER BY GAME_DT DESC LIMIT 10;` — you should see the rolling bat speed trending downward compared to the season average. This is the first anomaly — H-047's bat speed is fading.

### Step 5: Create alert views

Give CoCo this prompt:

> Create two secure views. First, CORE.V_BAT_SPEED_ALERTS that flags any hitter whose latest 21-game rolling BAT_SPEED is more than 2 mph below their season average. Include hitter name, team, season average, rolling average, and the difference. Second, CORE.V_CHASE_RATE_ANALYSIS that flags hitters with elite bat speed (top 10%) whose chase rate is above the league average, or any hitter whose chase rate has risen more than 5 percentage points above their season average.

> **Checkpoint:** Run `SELECT * FROM CORE.V_BAT_SPEED_ALERTS;` — you should see H-047 in the results. Run `SELECT * FROM CORE.V_CHASE_RATE_ANALYSIS;` — you should see H-023 (Chris Wilson) near the top, flagged 'elite speed, rising chase rate'. Other hitters may also be flagged: about 70 out-of-zone pitches over 21 games is a small sample, so 5-point swings happen by chance.

## What you just built

Four trusted views that clean the raw data, calculate rolling metrics, and automatically flag concerning trends. This is the analytics layer that the semantic view, AI extraction, and Streamlit app all build on.

Proceed to [Module 3: The Request Queue Challenge](03-request-queue-challenge.md).
