# Step 5 runbook — product metric layer

## Build order

1. `00_user_week.sql`
2. `01_weekly_product_kpis.sql`
3. `02_weekly_session_kpis.sql`
4. `03_engagement_kpis.sql`
5. `04_metric_reconciliation.sql`

## Validation

The reconciliation query requires:

- activated users never exceed active users
- active-user weekly denominators are positive in emitted weeks
- activation rates remain within [0,1]

Run the Python gate:

`ruff check src tests`

`pytest -q`

## Interpretation checklist

- Do not compare partial boundary weeks as though they were complete.
- Do not call average purchase value AOV until transaction integrity supports an order grain.
- Do not describe viewer-to-cart user rate as an ordered funnel.
- Do not call pseudonymous users known customers.
- Do not treat observed-window metrics as lifetime behaviour.

## Acceptance criteria

- North Star has a concrete v1 definition
- numerator, denominator, grain and window are documented
- safe division semantics are consistent in SQL/Python
- weekly boundary bias is visible
- supporting session and engagement KPIs exist
- metric invariants are executable
- metric helpers are unit tested
