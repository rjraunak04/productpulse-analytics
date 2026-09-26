# Step 4 runbook — behavioural layer

## Build order

1. `sql/behavioural/00_event_base.sql`
2. `sql/behavioural/01_session_base.sql`
3. `sql/behavioural/02_user_base.sql`
4. `sql/behavioural/03_session_event_sequence.sql`
5. `sql/behavioural/04_user_day.sql`

## Reconciliation

Run:

- `sql/quality/09_behavioural_reconciliation.sql`
- `sql/quality/10_session_invariants.sql`

The first quantifies events excluded from sessionization. The second verifies session-key and timestamp invariants.

## Code gate

`ruff check src tests`

`pytest -q`

## Acceptance criteria

- event, session, user, user-day and sequence grains are explicit
- session key is composite and non-null
- missing session IDs are not silently synthesized
- excluded-event coverage is measurable
- observed duration semantics are documented
- user-window metrics are not called lifetime metrics
- session journey flags are distinct from ordered funnels
- Python contract helpers are unit tested
