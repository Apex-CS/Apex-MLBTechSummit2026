/*
    ============================================================
    01_create_schemas.sql
    ============================================================
    Purpose:          Create the three schemas used by the lab:
                      RAW (landing), CORE (modeled), CONFIG.
    Prerequisites:    Run 00_bootstrap_account.sql first.
    Idempotent:       Yes — safe to re-run.
    ============================================================
*/

USE ROLE RL_SWING_DOCTOR_ADMIN;
USE WAREHOUSE SWING_DOCTOR_WH;
USE DATABASE SWING_DOCTOR_DB;

-- -----------------------------------------------------------------
-- Schemas
-- -----------------------------------------------------------------
CREATE SCHEMA IF NOT EXISTS RAW
    COMMENT = 'Raw landing area for CSV data loaded from the lab stage';

CREATE SCHEMA IF NOT EXISTS CORE
    COMMENT = 'Modeled and trusted metrics built during the lab';

CREATE SCHEMA IF NOT EXISTS CONFIG
    COMMENT = 'Configuration and threshold tables';

-- -----------------------------------------------------------------
-- Grant analyst read access to CORE
-- -----------------------------------------------------------------
GRANT USAGE ON SCHEMA CORE TO ROLE RL_SWING_DOCTOR_ANALYST;
GRANT SELECT ON ALL VIEWS IN SCHEMA CORE TO ROLE RL_SWING_DOCTOR_ANALYST;
GRANT SELECT ON FUTURE VIEWS IN SCHEMA CORE TO ROLE RL_SWING_DOCTOR_ANALYST;
GRANT SELECT ON ALL TABLES IN SCHEMA CORE TO ROLE RL_SWING_DOCTOR_ANALYST;
GRANT SELECT ON FUTURE TABLES IN SCHEMA CORE TO ROLE RL_SWING_DOCTOR_ANALYST;
