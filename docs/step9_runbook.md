# Step 9 runbook — growth economics

## Build order

1. `00_user_value.sql`
2. `01_weekly_revenue_metrics.sql`
3. `02_repeat_purchase.sql`
4. `03_first_user_source_value.sql`
5. `04_rfm_segments.sql`
6. `05_value_distribution.sql`
7. `sql/quality/13_economics_invariants.sql`

## Code gate

`ruff check src tests`

`pytest -q`

## Interpretation checks

- observed-window value is never labelled LTV
- no CAC/ROAS/payback is calculated without cost data
- first-user source is not described as session attribution
- repeat purchase remains event-based until transaction integrity is validated
- means are accompanied by distribution context
- RFM tiers are described as sample-relative

## Acceptance criteria

- weekly monetization metrics exist
- observed user value exists
- repeat-purchase behaviour exists
- first-user source value context exists
- RFM-style segmentation exists
- value-distribution diagnostics exist
- unsupported economics metrics are explicitly documented
- invariant checks and Python helpers are tested
