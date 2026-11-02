# Module 3: The Request Queue Challenge

**Time:** 0:50 to 1:10 (20 minutes)
**Goal:** Create a semantic view and race through five real-world questions using it.

## Context

In every organization, there is a request queue — questions waiting for an analyst to write a query. The semantic layer changes the game: once the definitions are in place, anyone can ask a question and get a consistent answer. In this module, you build the semantic layer, then race through five questions.

## Steps

### Step 1: Create the semantic view

Give CoCo this prompt:

> Create a semantic view called CORE.SV_SWING_DOCTOR over my CORE views. It should let people ask questions about hitters, their swing metrics, and trends. Define entities for HITTER (from STG_HITTERS with HITTER_ID, HITTER_NAME, TEAM_CD, BATS_CD, POSITION_CD) and SWING (from V_SWING_METRICS with BAT_SPEED, EXIT_VELOCITY, LAUNCH_ANGLE, ATTACK_ANGLE, SWING_LENGTH as measures, and GAME_DT, GAME_NUM, PITCH_TYPE_CD, CONTACT_OUTCOME_CD, CONTACT_QUALITY_CD, IS_CHASE_FLAG as attributes) and PITCH (from RAW.STG_PITCHES, every pitch seen, with PITCH_ZONE_CD and IS_SWING_FLAG). Add one-to-many relationships from HITTER to SWING and from HITTER to PITCH on HITTER_ID. Add a CHASE_RATE metric on PITCH: swings at out-of-zone pitches (zones 10-14) divided by out-of-zone pitches seen. Add AI_SQL_GENERATION instructions with these business definitions: a "swing change" means a change in average ATTACK_ANGLE (not bat speed), comparing games 1-90 with games 91-162; "contact quality" means average exit velocity and hard-hit rate on balls in play (CONTACT_OUTCOME_CD = 'in_play'); the All-Star break is game 81, so "since the All-Star break" compares GAME_NUM <= 81 with GAME_NUM > 81; "elite bat speed" means the top 10 percent of hitters by average bat speed; "chase rate" always means the PITCH CHASE_RATE metric, never a share of swings.

CoCo will generate a `CREATE SEMANTIC VIEW` statement. Review it and run it.

> **Checkpoint:** Run `DESCRIBE SEMANTIC VIEW CORE.SV_SWING_DOCTOR;` — you should see the entities and measures listed.

> **Note:** CoCo may point out that PITCH has no game date or game number, so chase rate cannot be broken out by game or by "since the All-Star break" yet, and offer to add a GAME entity. That is expected: the five challenge questions do not need it, so decline the offer and move on to Step 2.

### Step 2: The challenge

Five questions. Answer them as fast as you can using CoCo and the semantic view. For each question, give CoCo the question in plain English and let it generate and run the SQL.

---

**Question 1:**

> Which hitters have lost bat speed since the All-Star break?

*Hint: Compare average bat speed before game 81 vs after game 81.*

You should find **H-047** at or near the top — bat speed dropped ~2-3 mph after midseason.

---

**Question 2:**

> Whose swing changed, and did their contact quality follow?

*Hint: Look for hitters whose attack angle changed by more than 1 degree after game 90, then check if their exit velocity on balls in play also changed.*

You should find **H-112** — attack angle shifted up and exit velocity improved. A positive mechanical change.

---

**Question 3:**

> Who has elite bat speed but chases too many pitches?

*Hint: Find hitters in the top 10% of bat speed whose chase rate (out-of-zone swings / out-of-zone pitches, from STG_PITCHES) exceeds the league average.*

You should find **H-023** — elite bat speed but swinging at too many pitches outside the zone.

---

**Question 4:**

> Which team has the best barrel rate against fastballs?

*Hint: Filter to PITCH_TYPE_CD = 'FF' and CONTACT_OUTCOME_CD = 'in_play', then calculate barrel rate by team.*

---

**Question 5:**

> Rank hitters by bat speed improvement over the season.

*Hint: Compare average bat speed in the first 21 games vs the last 21 games.*

---

> **Checkpoint:** You answered all five questions. You found the three planted anomalies: H-047 (bat speed fade), H-112 (swing change), H-023 (chase rate). If you are stuck on any question, the facilitator has reference solutions.

## What you just built

A semantic layer with shared definitions that gives everyone consistent answers. The same five questions that would have been five tickets in a request queue were answered in minutes.

Proceed to [Module 4: Read the Scouting Notes](04-scouting-notes.md).
