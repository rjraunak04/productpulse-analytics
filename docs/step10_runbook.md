# Step 10 runbook — inactivity and survival

## Build order

1. `00_activity_intervals.sql`
2. `01_return_time_distribution.sql`
3. `02_km_inputs.sql`
4. feed aggregated KM inputs to the Python `kaplan_meier` estimator
5. `03_current_inactivity.sql`
6. `04_inactivity_summary.sql`
7. `sql/quality/14_survival_invariants.sql`

## Code gate

`ruff check src tests`

`pytest -q`

## Required checks

- durations are non-negative
- observed return events move forward in time
- right-censored intervals remain censored
- no censored user is labelled permanently churned
- risk-set counts never become negative
- survival probabilities remain interpretable from 1 toward 0

## Acceptance criteria

- activity-to-next-activity intervals exist
- censoring is explicit
- return-time distribution exists
- KM-ready inputs exist
- tested Kaplan-Meier estimator exists
- endpoint inactivity states exist
- permanent churn terminology is prohibited
- survival invariants are executable
