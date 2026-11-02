/*
    ============================================================
    02_create_raw_tables.sql
    ============================================================
    Purpose:          Create the four raw landing tables for
                      CSV data: hitters, games, swings, scouting
                      notes.
    Prerequisites:    Run 01_create_schemas.sql first.
    Idempotent:       Yes — CREATE IF NOT EXISTS.
    ============================================================
*/

USE ROLE RL_SWING_DOCTOR_ADMIN;
USE WAREHOUSE SWING_DOCTOR_WH;
USE DATABASE SWING_DOCTOR_DB;
USE SCHEMA RAW;

-- -----------------------------------------------------------------
-- STG_HITTERS
-- -----------------------------------------------------------------
CREATE TABLE IF NOT EXISTS STG_HITTERS (
    HITTER_ID      VARCHAR(10)   NOT NULL  COMMENT 'Unique hitter identifier (H-001 to H-150)'
    ,HITTER_NAME   VARCHAR(100)  NOT NULL  COMMENT 'Generated full name of the hitter'
    ,TEAM_CD       VARCHAR(3)    NOT NULL  COMMENT 'Three-letter team code (e.g. BOS, LAD, MIA)'
    ,BATS_CD       VARCHAR(1)    NOT NULL  COMMENT 'Batting hand: L=left, R=right, S=switch'
    ,POSITION_CD   VARCHAR(3)    NOT NULL  COMMENT 'Fielding position code (C, 1B, 2B, SS, 3B, OF, DH)'
    ,AGE_NUM       NUMBER(3,0)   NOT NULL  COMMENT 'Player age in years'
) COMMENT = 'Raw hitter roster data — one row per hitter in the synthetic league';

-- -----------------------------------------------------------------
-- STG_GAMES
-- -----------------------------------------------------------------
CREATE TABLE IF NOT EXISTS STG_GAMES (
    GAME_ID        VARCHAR(10)   NOT NULL  COMMENT 'Unique game identifier (G-00001+)'
    ,GAME_DT       DATE          NOT NULL  COMMENT 'Date the game was played'
    ,GAME_NUM      NUMBER(5,0)   NOT NULL  COMMENT 'Sequential game number within the season'
    ,HOME_TEAM_CD  VARCHAR(3)    NOT NULL  COMMENT 'Home team code'
    ,AWAY_TEAM_CD  VARCHAR(3)    NOT NULL  COMMENT 'Away team code'
) COMMENT = 'Season schedule — one row per game in the synthetic 162-game season';

-- -----------------------------------------------------------------
-- STG_SWINGS
-- -----------------------------------------------------------------
CREATE TABLE IF NOT EXISTS STG_SWINGS (
    SWING_ID           VARCHAR(15)    NOT NULL  COMMENT 'Unique swing identifier (SW-0000001+)'
    ,GAME_ID           VARCHAR(10)    NOT NULL  COMMENT 'FK to STG_GAMES — which game this swing occurred in'
    ,HITTER_ID         VARCHAR(10)    NOT NULL  COMMENT 'FK to STG_HITTERS — who swung'
    ,INNING_NUM        NUMBER(3,0)    NOT NULL  COMMENT 'Inning number (1-9+)'
    ,PITCH_NUM         NUMBER(3,0)    NOT NULL  COMMENT 'Pitch number within the plate appearance'
    ,PITCH_TYPE_CD     VARCHAR(2)     NOT NULL  COMMENT 'Pitch type code: FF=fastball, SL=slider, CH=changeup, CU=curve, SI=sinker, CT=cutter'
    ,PITCH_VELOCITY    NUMBER(5,1)    NOT NULL  COMMENT 'Pitch velocity in mph'
    ,PITCH_SPIN_RATE   NUMBER(6,0)    NOT NULL  COMMENT 'Pitch spin rate in rpm'
    ,PITCH_ZONE_CD     VARCHAR(2)     NOT NULL  COMMENT 'Pitch location zone: 1-9=strike zone, 10-14=out of zone (chase)'
    ,BAT_SPEED         NUMBER(5,1)              COMMENT 'Bat speed in mph at point of contact (NULL = sensor outage)'
    ,SWING_LENGTH      NUMBER(4,1)    NOT NULL  COMMENT 'Swing length in feet'
    ,ATTACK_ANGLE      NUMBER(5,1)    NOT NULL  COMMENT 'Attack angle in degrees'
    ,CONTACT_OUTCOME_CD VARCHAR(10)   NOT NULL  COMMENT 'Outcome: whiff, foul, or in_play'
    ,EXIT_VELOCITY     NUMBER(5,1)              COMMENT 'Exit velocity in mph (NULL on whiff)'
    ,LAUNCH_ANGLE      NUMBER(5,1)              COMMENT 'Launch angle in degrees (NULL on whiff)'
    ,HIT_RESULT_CD     VARCHAR(10)              COMMENT 'Hit result: single, double, triple, hr, out (NULL on whiff/foul)'
) COMMENT = 'Swing-level bat tracking data — one row per swing in the synthetic season. Contains planted DQ issues for Module 2.';

-- -----------------------------------------------------------------
-- STG_PITCHES
-- -----------------------------------------------------------------
CREATE TABLE IF NOT EXISTS STG_PITCHES (
    PITCH_ID          VARCHAR(12)    NOT NULL  COMMENT 'Unique pitch identifier (PT-0000001+)'
    ,GAME_ID          VARCHAR(10)    NOT NULL  COMMENT 'FK to STG_GAMES'
    ,HITTER_ID        VARCHAR(10)    NOT NULL  COMMENT 'FK to STG_HITTERS — the batter who saw the pitch'
    ,PA_NUM           NUMBER(2,0)    NOT NULL  COMMENT 'Plate appearance number within the game for this hitter'
    ,PITCH_NUM        NUMBER(2,0)    NOT NULL  COMMENT 'Pitch number within the plate appearance'
    ,PITCH_TYPE_CD    VARCHAR(5)     NOT NULL  COMMENT 'Pitch type code: FF, SL, CH, CU, SI, CT'
    ,PITCH_VELOCITY   NUMBER(5,1)    NOT NULL  COMMENT 'Pitch velocity in mph'
    ,PITCH_ZONE_CD    VARCHAR(2)     NOT NULL  COMMENT 'Pitch location zone: 1-9=strike zone, 10-14=out of zone'
    ,IS_SWING_FLAG    BOOLEAN        NOT NULL  COMMENT 'TRUE when the hitter swung, FALSE when he took the pitch'
    ,SWING_ID         VARCHAR(12)              COMMENT 'FK to STG_SWINGS when IS_SWING_FLAG is TRUE (NULL on takes)'
) COMMENT = 'Every pitch seen, swing or take — the denominator for chase rate (swings at out-of-zone pitches / out-of-zone pitches seen)';

-- -----------------------------------------------------------------
-- STG_SCOUTING_NOTES
-- -----------------------------------------------------------------
CREATE TABLE IF NOT EXISTS STG_SCOUTING_NOTES (
    NOTE_ID        VARCHAR(10)    NOT NULL  COMMENT 'Unique scouting note identifier (SN-0001+)'
    ,HITTER_ID     VARCHAR(10)    NOT NULL  COMMENT 'FK to STG_HITTERS — which hitter the note is about'
    ,SCOUT_NAME    VARCHAR(100)   NOT NULL  COMMENT 'Name of the scout who wrote the note'
    ,NOTE_DT       DATE           NOT NULL  COMMENT 'Date the scouting observation was recorded'
    ,NOTE_TEXT     VARCHAR(2000)  NOT NULL  COMMENT 'Free-text scouting report — unstructured observations about the hitter'
) COMMENT = 'Free-text scouting reports — used in Module 4 for AI extraction and classification';
