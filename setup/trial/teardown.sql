/*
    ============================================================
    teardown.sql
    ============================================================
    Purpose:          Clean up all lab objects. Run after the lab
                      to free trial account resources.
    Idempotent:       Yes — all statements use IF EXISTS.
    WARNING:          This drops the database and all data.
    ============================================================
*/

USE ROLE ACCOUNTADMIN;

-- Drop database (includes all schemas, tables, views, stages, the
-- semantic view, agent, and the Streamlit app)
DROP DATABASE IF EXISTS SWING_DOCTOR_DB;

-- Drop warehouse
DROP WAREHOUSE IF EXISTS SWING_DOCTOR_WH;

-- Drop roles
DROP ROLE IF EXISTS RL_SWING_DOCTOR_ANALYST;
DROP ROLE IF EXISTS RL_SWING_DOCTOR_ADMIN;
