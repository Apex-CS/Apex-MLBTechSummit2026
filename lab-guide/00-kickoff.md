# Module 0: Kickoff

**Time:** 0:00 to 0:10 (10 minutes)
**Goal:** Get logged in, verify your environment, and understand what you are building.

## Welcome

You are about to build **Swing Doctor** — an early warning system that detects when a hitter's bat speed is fading, their swing mechanics have changed, or their plate discipline is slipping. You will go from raw CSV data to a working Streamlit app in two hours.

Everything runs in the browser. No local installs. No coding experience required — you will use Cortex Code, Snowflake's agentic AI assistant, to write the SQL and Python for you.

## What you will build

| Module | What you create |
|--------|----------------|
| 1 | A tour of your governed workspace: role, warehouse, database, and loaded data |
| 2 | Trusted metrics: cleaned swing data, rolling averages, and alert views |
| 3 | A semantic layer that answers baseball questions in plain English |
| 4 | AI-extracted insights from free-text scouting reports |
| 5 | A Streamlit app with trend charts, alerts, and a question box |

## Environment check

1. Open [app.snowflake.com](https://app.snowflake.com) in a **new tab** in Chrome or Edge (Ctrl+click on Windows, Cmd+click on Mac) so this guide stays open
2. Log in with the username and password provided to you (`USER<nn>`)
3. On first sign-in, Snowflake asks you to set up multi-factor authentication. Choose **Passkey** or **Authenticator** and follow the prompts (have your phone ready). If you get stuck, raise your hand.
4. Click **Projects** in the left sidebar, then **Workspaces**
5. Click **+ Add new**, select **SQL File**, and give it a name (for example `Swing Doctor`)
6. Run this query to confirm your session is working:

```sql
SELECT CURRENT_USER(), CURRENT_ROLE(), CURRENT_REGION();
```

You should see `USER<nn>`, `USER<nn>_ROLE`, and the cloud region.

> **Checkpoint:** If the query runs and returns results, you are ready. If you see an error, raise your hand or message the facilitator.

## Get the lab files

1. Go to the GitHub repo: [github.com/Apex-CS/Apex-MLBTechSummit2026](https://github.com/Apex-CS/Apex-MLBTechSummit2026)
2. Click **Code** > **Download ZIP**, or clone the repo
3. Keep `app/pyproject.toml` handy — you upload it with your app in Module 5. Your data is already loaded; the `data/` CSV files are included for reference.

You are ready. Proceed to [Module 1: The Enabler](01-the-enabler.md).
