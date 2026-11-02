/*
    ============================================================
    03_stage_and_load.sql
    ============================================================
    Purpose:          Create an internal stage, define file
                      formats, and load CSV data into raw tables.
    Prerequisites:    Run 02_create_raw_tables.sql first.
                      Upload the five CSV files from the GitHub
                      repo (data/ folder) to the stage via
                      Snowsight before running the COPY commands.
    Idempotent:       Yes — COPY INTO skips already-loaded files.
    ============================================================
*/

USE ROLE RL_SWING_DOCTOR_ADMIN;
USE WAREHOUSE SWING_DOCTOR_WH;
USE DATABASE SWING_DOCTOR_DB;
USE SCHEMA RAW;

-- -----------------------------------------------------------------
-- File format
-- -----------------------------------------------------------------
CREATE FILE FORMAT IF NOT EXISTS FF_CSV_LAB
    TYPE            = CSV
    FIELD_DELIMITER = ','
    SKIP_HEADER     = 1
    FIELD_OPTIONALLY_ENCLOSED_BY = '"'
    NULL_IF         = ('')
    EMPTY_FIELD_AS_NULL = TRUE
    COMMENT         = 'CSV format for lab data files — header row, comma-delimited, double-quote enclosed';

-- -----------------------------------------------------------------
-- Internal stage
-- -----------------------------------------------------------------
CREATE STAGE IF NOT EXISTS INT_LAB_STAGE
    FILE_FORMAT = FF_CSV_LAB
    COMMENT     = 'Internal stage for hands-on lab CSV files';

-- -----------------------------------------------------------------
-- IMPORTANT: Upload CSV files before running the COPY commands
-- -----------------------------------------------------------------
-- In Snowsight:
--   1. Navigate to Data > Databases > SWING_DOCTOR_DB > RAW > Stages > INT_LAB_STAGE
--   2. Click "+ Files" and upload these files from the GitHub repo data/ folder:
--      - hitters.csv
--      - games.csv
--      - swings.csv
--      - pitches.csv
--      - scouting_notes.csv
--
-- Or from SnowSQL / Cortex Code terminal:
--   PUT file://path/to/data/hitters.csv @INT_LAB_STAGE AUTO_COMPRESS=FALSE;
--   PUT file://path/to/data/games.csv @INT_LAB_STAGE AUTO_COMPRESS=FALSE;
--   PUT file://path/to/data/swings.csv @INT_LAB_STAGE AUTO_COMPRESS=FALSE;
--   PUT file://path/to/data/pitches.csv @INT_LAB_STAGE AUTO_COMPRESS=FALSE;
--   PUT file://path/to/data/scouting_notes.csv @INT_LAB_STAGE AUTO_COMPRESS=FALSE;
-- -----------------------------------------------------------------

-- -----------------------------------------------------------------
-- Load hitters
-- -----------------------------------------------------------------
COPY INTO STG_HITTERS
FROM @INT_LAB_STAGE/hitters.csv
FILE_FORMAT = FF_CSV_LAB
ON_ERROR    = ABORT_STATEMENT;

-- -----------------------------------------------------------------
-- Load games
-- -----------------------------------------------------------------
COPY INTO STG_GAMES
FROM @INT_LAB_STAGE/games.csv
FILE_FORMAT = FF_CSV_LAB
ON_ERROR    = ABORT_STATEMENT;

-- -----------------------------------------------------------------
-- Load swings
-- -----------------------------------------------------------------
COPY INTO STG_SWINGS
FROM @INT_LAB_STAGE/swings.csv
FILE_FORMAT = FF_CSV_LAB
ON_ERROR    = ABORT_STATEMENT;

-- -----------------------------------------------------------------
-- Load pitches (every pitch seen, swings and takes)
-- -----------------------------------------------------------------
COPY INTO STG_PITCHES
FROM @INT_LAB_STAGE/pitches.csv
FILE_FORMAT = FF_CSV_LAB
ON_ERROR    = ABORT_STATEMENT;

-- -----------------------------------------------------------------
-- Load scouting notes
-- -----------------------------------------------------------------
COPY INTO STG_SCOUTING_NOTES
FROM @INT_LAB_STAGE/scouting_notes.csv
FILE_FORMAT = FF_CSV_LAB
ON_ERROR    = ABORT_STATEMENT;
