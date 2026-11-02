/*
    ============================================================
    04_verify_load.sql
    ============================================================
    Purpose:          Verify that all five tables loaded correctly.
                      Run after 03_stage_and_load.sql.
    Expected counts:
        STG_HITTERS         ~150 rows
        STG_GAMES           ~810 rows
        STG_SWINGS          ~155,000 rows (includes planted duplicates)
        STG_PITCHES         ~289,000 rows (swings + takes)
        STG_SCOUTING_NOTES  ~430 rows
    ============================================================
*/

USE ROLE RL_SWING_DOCTOR_ADMIN;
USE WAREHOUSE SWING_DOCTOR_WH;
USE DATABASE SWING_DOCTOR_DB;
USE SCHEMA RAW;

-- -----------------------------------------------------------------
-- Row counts
-- -----------------------------------------------------------------
SELECT 'STG_HITTERS' AS TABLE_NAME, COUNT(*) AS ROW_COUNT FROM STG_HITTERS
UNION ALL
SELECT 'STG_GAMES', COUNT(*) FROM STG_GAMES
UNION ALL
SELECT 'STG_SWINGS', COUNT(*) FROM STG_SWINGS
UNION ALL
SELECT 'STG_PITCHES', COUNT(*) FROM STG_PITCHES
UNION ALL
SELECT 'STG_SCOUTING_NOTES', COUNT(*) FROM STG_SCOUTING_NOTES
ORDER BY TABLE_NAME;

-- -----------------------------------------------------------------
-- Spot checks
-- -----------------------------------------------------------------

-- Sample hitters
SELECT * FROM STG_HITTERS LIMIT 5;

-- Sample swings
SELECT * FROM STG_SWINGS LIMIT 5;

-- Confirm teams
SELECT TEAM_CD, COUNT(*) AS HITTER_COUNT
FROM STG_HITTERS
GROUP BY TEAM_CD
ORDER BY TEAM_CD;

-- Confirm season date range
SELECT
    MIN(GAME_DT) AS SEASON_START_DT
    ,MAX(GAME_DT) AS SEASON_END_DT
    ,COUNT(DISTINCT GAME_DT) AS GAME_DAYS_COUNT
FROM STG_GAMES;
