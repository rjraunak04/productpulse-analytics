# Step 3 runbook — event data quality

## Run order

Execute the SQL diagnostics in numerical order:

1. `00_quality_summary.sql`
2. `01_duplicate_events.sql`
3. `02_daily_completeness.sql`
4. `03_session_parameter_coverage.sql`
5. `04_purchase_integrity.sql`
6. `05_transaction_duplicates.sql`
7. `06_timestamp_consistency.sql`
8. `07_required_event_presence.sql`
9. `08_item_integrity.sql`

Record observed values before promoting any warning into a numeric threshold.

## Local code gate

Install the package in editable development mode and run:

`python -m pip install -e ".[dev]"`

`ruff check src tests`

`pytest -q`

## Acceptance criteria

- quality dimensions are explicit
- blocking rules and warning rules are separated
- no arbitrary empirical threshold is invented
- duplicate handling is diagnostic, not destructive
- purchase/item integrity is checked
- session parameter coverage is measured by event
- reusable Python evaluators are unit-tested
- CI runs lint and tests on pushes/PRs
