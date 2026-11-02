/*
    ============================================================
    00_bootstrap_account.sql
    ============================================================
    Purpose:          One-time account setup for the Swing Doctor
                      hands-on lab. Creates roles, a warehouse,
                      and the lab database on a clean trial account.
    Prerequisites:    ACCOUNTADMIN role (default on trial accounts).
    Idempotent:       Yes — safe to re-run.
    ============================================================
*/

-- -----------------------------------------------------------------
-- Roles
-- -----------------------------------------------------------------
USE ROLE ACCOUNTADMIN;

CREATE ROLE IF NOT EXISTS RL_SWING_DOCTOR_ADMIN
    COMMENT = 'Admin role for the Swing Doctor hands-on lab';

CREATE ROLE IF NOT EXISTS RL_SWING_DOCTOR_ANALYST
    COMMENT = 'Analyst role for read-only access to Swing Doctor data';

-- Roll up to SYSADMIN per Snowflake RBAC best practices
GRANT ROLE RL_SWING_DOCTOR_ADMIN TO ROLE SYSADMIN;
GRANT ROLE RL_SWING_DOCTOR_ANALYST TO ROLE RL_SWING_DOCTOR_ADMIN;

-- Grant the admin role to the current user
GRANT ROLE RL_SWING_DOCTOR_ADMIN TO USER IDENTIFIER(CURRENT_USER());

-- -----------------------------------------------------------------
-- Warehouse
-- -----------------------------------------------------------------
CREATE WAREHOUSE IF NOT EXISTS SWING_DOCTOR_WH
    WAREHOUSE_SIZE = 'XSMALL'
    AUTO_SUSPEND   = 120
    AUTO_RESUME    = TRUE
    COMMENT        = 'Compute warehouse for the Swing Doctor hands-on lab';

GRANT USAGE ON WAREHOUSE SWING_DOCTOR_WH TO ROLE RL_SWING_DOCTOR_ADMIN;
GRANT USAGE ON WAREHOUSE SWING_DOCTOR_WH TO ROLE RL_SWING_DOCTOR_ANALYST;

-- -----------------------------------------------------------------
-- Database
-- -----------------------------------------------------------------
CREATE DATABASE IF NOT EXISTS SWING_DOCTOR_DB
    COMMENT = 'Swing Doctor hands-on lab — synthetic bat tracking data';

GRANT OWNERSHIP ON DATABASE SWING_DOCTOR_DB TO ROLE RL_SWING_DOCTOR_ADMIN
    COPY CURRENT GRANTS;

-- -----------------------------------------------------------------
-- Enable cross-region inference for Cortex AI functions
-- (required for llama3.3-70b on trial accounts)
-- -----------------------------------------------------------------
ALTER ACCOUNT SET CORTEX_ENABLED_CROSS_REGION = 'ANY_REGION';

-- -----------------------------------------------------------------
-- Module 5: the container-runtime Streamlit app installs altair from
-- Snowflake's PyPI mirror and runs on SYSTEM_COMPUTE_POOL_CPU
-- -----------------------------------------------------------------
GRANT DATABASE ROLE SNOWFLAKE.PYPI_REPOSITORY_USER TO ROLE RL_SWING_DOCTOR_ADMIN;
GRANT USAGE ON COMPUTE POOL SYSTEM_COMPUTE_POOL_CPU TO ROLE RL_SWING_DOCTOR_ADMIN;

-- -----------------------------------------------------------------
-- Switch to the admin role for all subsequent scripts
-- -----------------------------------------------------------------
USE ROLE RL_SWING_DOCTOR_ADMIN;
USE WAREHOUSE SWING_DOCTOR_WH;
USE DATABASE SWING_DOCTOR_DB;
