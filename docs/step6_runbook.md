# Step 6 runbook — ordered funnel

## Build order

1. `00_funnel_event_stream.sql`
2. `01_ordered_session_funnel.sql`
3. `02_funnel_summary.sql`
4. `03_funnel_by_device.sql`
5. materialize/view the canonical ordered funnel if timing/invariant queries are run
6. `04_funnel_timing.sql`
7. `sql/quality/11_funnel_invariants.sql`

## Code validation

`ruff check src tests`

`pytest -q`

## Required interpretation checks

- stage counts must be non-increasing
- each reached stage timestamp must be >= the prior reached stage
- one row per composite session key
- undefined ratios remain NULL/None
- presence flags are not substituted for ordered progression
- segment differences are descriptive, not causal

## Acceptance criteria

- canonical funnel is explicit and version-controlled
- progression is same-session and ordered
- step and overall conversion are separated
- absolute drop-off is available
- stage timing is supported
- device segmentation is supported without segment drift
- invariants and Python summary logic are tested
