# Step 11 runbook — decision application

## Install

`pip install -e .`

`pip install -r requirements-app.txt`

## Populate

Run the relevant BigQuery analytical queries and export validated aggregate outputs into `reports/app_data/` using the filenames documented there.

Do not commit raw GA4 data, credentials, or fabricated KPI outputs.

## Launch

`streamlit run app/streamlit_app.py`

## Code gate

`ruff check src tests`

`pytest -q`

## Recruiter walkthrough

Use this order:

1. executive overview
2. ordered funnel
3. cohort retention
4. experimentation methodology
5. observed economics
6. inactivity/survival

Keep the story decision-oriented rather than touring every chart.

## Acceptance criteria

- one lightweight application entrypoint exists
- analytical SQL remains the metric source of truth
- app has safe empty states
- raw data is not required in Git
- experiment simulation disclosure is visible in-app
- retention censoring boundary is visible
- economics limitations are visible
- inactivity is not labelled permanent churn
- app data helpers are unit tested
