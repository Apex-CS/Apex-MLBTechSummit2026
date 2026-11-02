# Module 1: The Enabler

**Time:** 0:10 to 0:25 (15 minutes)
**Goal:** Use Cortex Code to tour the governed foundation that was built for you — roles, warehouse, database, schemas, tables, and loaded data — and see how it was set up.

## Context

Every self-service analytics project starts with someone building the foundation. On this lab account, the **enabler** work is already done: the lab team created your role, a shared warehouse, and your own database with a full season of data loaded. In this module you use Cortex Code to inspect that foundation and see the pattern behind it, so you can repeat it on your own account. For the rest of the lab you work as the **end user**.

This is also your warm-up with Cortex Code (CoCo): you ask in plain English, and it writes and runs the SQL for you.

Throughout this guide, `<nn>` is the number in your username (for example `USER07` → `07`).

## About the data

Everything in this lab is **synthetic**. A generator script created a fictional 10-team league with ~150 hitters and a full 162-game season, so there is no real player, team, or game data. The columns and value ranges are modeled on **MLB Statcast bat tracking** (the Hawk-Eye metrics published on Baseball Savant): bat speed, swing length, attack angle, exit velocity, launch angle, pitch type, and zone.

Typical values you will see:

| Metric | Typical value |
|--------|---------------|
| Bat speed | ~70 mph average (individual hitters range roughly 61-82) |
| Swing length | ~7 ft |
| Attack angle | ~12° |
| Exit velocity | ~88 mph average |
| Pitch mix | Four-seam 35%, slider 20%, changeup 15%, curve 12%, sinker 10%, cutter 8% |

A few rules are simplified compared with real Statcast; Module 2 points them out. The data also contains a few planted data quality problems and some hidden player storylines. Finding them is your job in the modules ahead.

## Steps

### Step 1: Open Cortex Code

In Snowsight, open **Cortex Code** (the AI assistant panel). Make sure your session is set to:
- **Role:** `USER<nn>_ROLE`
- **Database:** `SWING_DOCTOR_<nn>`
- **Warehouse:** `SWING_DOCTOR_WH`

### Step 2: Check your role and workspace

Give CoCo this prompt:

> Who am I logged in as? Show my current user, role, warehouse, and database, and list every database my role can see.

> **Checkpoint:** You should see `USER<nn>`, `USER<nn>_ROLE`, `SWING_DOCTOR_WH`, and `SWING_DOCTOR_<nn>` — and only one database, `SWING_DOCTOR_<nn>`. Your role owns your database and cannot see anyone else's.

<details>
<summary>Prefer to run the SQL yourself?</summary>

```sql
SELECT CURRENT_USER(), CURRENT_ROLE(), CURRENT_WAREHOUSE(), CURRENT_DATABASE();
SHOW DATABASES LIKE 'SWING_DOCTOR_%';
```
</details>

### Step 3: Explore the schemas

Give CoCo this prompt:

> List the schemas in SWING_DOCTOR_<nn> and the tables in each one.

| Schema | Purpose |
|--------|---------|
| RAW | Where the CSV data lands |
| CORE | Where you build trusted metrics and views (empty for now) |
| CONFIG | For configuration tables (used later) |

### Step 4: Verify the loaded data

Give CoCo this prompt:

> Show me the row count for every table in the RAW schema.

| Table | Expected Rows |
|-------|---------------|
| STG_HITTERS | 150 |
| STG_GAMES | 810 |
| STG_SWINGS | ~155,000 |
| STG_PITCHES | ~289,000 (every pitch seen: swings and takes) |
| STG_SCOUTING_NOTES | ~430 |

> **Checkpoint:** All five tables have data. If any show 0 rows, raise your hand.

<details>
<summary>Prefer to run the SQL yourself?</summary>

```sql
SELECT 'STG_HITTERS' AS TABLE_NAME, COUNT(*) AS ROW_COUNT FROM RAW.STG_HITTERS
UNION ALL SELECT 'STG_GAMES', COUNT(*) FROM RAW.STG_GAMES
UNION ALL SELECT 'STG_SWINGS', COUNT(*) FROM RAW.STG_SWINGS
UNION ALL SELECT 'STG_PITCHES', COUNT(*) FROM RAW.STG_PITCHES
UNION ALL SELECT 'STG_SCOUTING_NOTES', COUNT(*) FROM RAW.STG_SCOUTING_NOTES;
```
</details>

### Step 5: Understand the data model

Give CoCo this prompt:

> Describe the tables in RAW and how they relate to each other. Which columns join them, and what does one row in each table represent?

CoCo should tell you that hitters and games are the dimensions, that each swing belongs to one hitter in one game, that `STG_PITCHES` holds every pitch seen (swings and takes), and that scouting notes are free text about a hitter.

Then ask a first question about the data:

> Show me 5 sample rows from RAW.STG_SWINGS and explain what each column means for a hitter.

### Step 6: See how it was built — and why sources matter

This step is a quick experiment in how to get better answers from an AI assistant.

**6a. Ask without a source.** Give CoCo this prompt:

> Show me the DDL for SWING_DOCTOR_<nn>.RAW.STG_SWINGS and the grants on my database. How would I rebuild this foundation on my own Snowflake account?

Read the answer. The DDL and grants come straight from your database, so they are accurate. For the rebuild, though, CoCo has nothing to go on and has to guess: it may suggest data shares, Marketplace listings, downloading data from somewhere else, or asking an administrator for help. None of that is wrong in general, but none of it is how this lab was actually built.

**6b. Ask again, grounded in a real source.** Repeat the same prompt, this time pointing CoCo at the lab's code base:

> Show me the DDL for SWING_DOCTOR_<nn>.RAW.STG_SWINGS and the grants on my database. Then explain how I would rebuild this foundation on my own Snowflake trial account using the lab's public repo, https://github.com/Apex-CS/Apex-MLBTechSummit2026. Its setup/trial folder has five scripts run in order: 00_bootstrap_account.sql (roles, warehouse, database, Cortex and Streamlit grants), 01_create_schemas.sql, 02_create_raw_tables.sql, 03_stage_and_load.sql (internal stage plus COPY INTO from the repo's data/ CSVs, uploaded through Snowsight), and 04_verify_load.sql. Summarize what each script does in one or two sentences. Do not run anything.

This time CoCo should describe a five-step rebuild that uses only the repo: run the bootstrap and schema scripts, create the tables, upload the CSVs from `data/` to the stage and run `COPY INTO`, then verify the row counts.

> **The lesson:** an AI assistant is only as good as the context you give it. When a code base, existing scripts, table DDL, or documentation exist, name them in your prompt. You get answers that match how things are actually done in your organization instead of a generic best guess. You will use this habit in every module that follows: each prompt names the exact tables, columns, and rules to use.

The lab team used the same scripts on this account, then cloned one loaded database for every attendee with zero-copy cloning, so all 150 copies share one set of storage.

## What you just built

You now know your governed workspace: your own role, a right-sized warehouse, three schemas with clear purposes, and a full season of synthetic bat tracking data. You also know how to work with Cortex Code — ask in plain English, ground your prompt in real sources, review the SQL it writes, check the result. This is the foundation every later module builds on.

Proceed to [Module 2: Trusted Metrics](02-trusted-metrics.md).
