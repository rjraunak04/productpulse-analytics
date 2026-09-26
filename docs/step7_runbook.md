# Step 7 runbook — cohorts and retention

## Build order

1. `00_user_week_activity.sql`
2. `01_user_cohorts.sql`
3. `02_classic_weekly_retention.sql`
4. `03_retention_matrix.sql`
5. `04_user_lifecycle.sql`
6. `05_weekly_growth_accounting.sql`
7. `06_cohort_followup.sql`
8. `sql/quality/12_retention_invariants.sql`

## Code gate

`ruff check src tests`

`pytest -q`

## Required checks

- W0 retained users equal cohort size
- retained users never exceed cohort size
- retention rates stay within [0,1]
- no negative cohort-relative week
- unavailable future weeks remain NULL/unobserved
- first observed week is never described as verified signup
- newly inactive is not described as permanent churn

## Acceptance criteria

- reusable user-week and cohort grains exist
- classic weekly retention is explicit
- long-form and matrix outputs exist
- lifecycle states distinguish retained and resurrected activity
- weekly growth accounting exists
- cohort follow-up/right censoring is visible
- invariants and Python semantics are tested
