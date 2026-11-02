# Module 1: The Enabler

**Time:** 0:10 to 0:25 (15 minutes)
**Goal:** Tour the governed foundation that was built for you — roles, warehouse, database, schemas, tables, and loaded data — and see how it was set up.

## Context

Every self-service analytics project starts with someone building the foundation. On this lab account, the **enabler** work is already done: the lab team created your role, a shared warehouse, and your own database with a full season of data loaded. In this module you inspect that foundation and see the pattern behind it, so you can repeat it on your own account. For the rest of the lab you work as the **end user**.

Throughout this guide, `<nn>` is the number in your username (for example `USER07` → `07`).

## Steps

### Step 1: Check your role and workspace

Run:

```sql
SELECT CURRENT_USER(), CURRENT_ROLE(), CURRENT_WAREHOUSE(), CURRENT_DATABASE();
```

> **Checkpoint:** You should see `USER<nn>`, `USER<nn>_ROLE`, `SWING_DOCTOR_WH`, and `SWING_DOCTOR_<nn>`. If the role or database is different, select them in the worksheet's context menu at the top of the editor.

Your role owns your database and everything in it, and it cannot see anyone else's database. Try it:

```sql
SHOW DATABASES LIKE 'SWING_DOCTOR_%';
```

You should see only `SWING_DOCTOR_<nn>`.

### Step 2: Explore the schemas

```sql
SHOW SCHEMAS IN DATABASE SWING_DOCTOR_<nn>;
```

| Schema | Purpose |
|--------|---------|
| RAW | Where the CSV data lands |
| CORE | Where you build trusted metrics and views (empty for now) |
| CONFIG | For configuration tables (used later) |

### Step 3: Verify the loaded data

```sql
SELECT 'STG_HITTERS' AS TABLE_NAME, COUNT(*) AS ROW_COUNT FROM RAW.STG_HITTERS
UNION ALL SELECT 'STG_GAMES', COUNT(*) FROM RAW.STG_GAMES
UNION ALL SELECT 'STG_SWINGS', COUNT(*) FROM RAW.STG_SWINGS
UNION ALL SELECT 'STG_PITCHES', COUNT(*) FROM RAW.STG_PITCHES
UNION ALL SELECT 'STG_SCOUTING_NOTES', COUNT(*) FROM RAW.STG_SCOUTING_NOTES;
```

| Table | Expected Rows |
|-------|---------------|
| STG_HITTERS | 150 |
| STG_GAMES | 810 |
| STG_SWINGS | ~155,000 |
| STG_PITCHES | ~289,000 (every pitch seen: swings and takes) |
| STG_SCOUTING_NOTES | ~430 |

> **Checkpoint:** All five tables have data. If any show 0 rows, raise your hand.

### Step 4: See how it was built

Ask Cortex Code:

> Describe the tables in RAW and how they relate to each other.

The scripts in `setup/trial/` in the lab repo show how to build this same foundation from scratch on your own Snowflake account: roles, an X-Small warehouse, the database and schemas, the landing tables, and a stage with `COPY INTO` loads. The lab team used the same pattern here, then cloned one loaded database for every attendee with zero-copy cloning, so all 150 copies share one set of storage.

## What you just built

You now know your governed workspace: your own role, a right-sized warehouse, three schemas with clear purposes, and a full season of synthetic bat tracking data. This is the foundation every later module builds on.

Proceed to [Module 2: Trusted Metrics](02-trusted-metrics.md).
