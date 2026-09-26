# Step 2 runbook — GA4 data foundation

## Prerequisites

1. A Google Cloud project with the BigQuery API available.
2. Permission to run queries against BigQuery public datasets.
3. Optional local authentication only when executing through Python/CLI later.

No service-account key belongs in this repository.

## Profiling order

Run these queries in BigQuery:

1. `sql/staging/00_source_inventory.sql`
2. `sql/staging/01_event_name_profile.sql`
3. `sql/staging/02_event_param_profile.sql`
4. `sql/staging/03_core_dimension_profile.sql`
5. `sql/staging/04_ecommerce_profile.sql`
6. `sql/staging/05_items_profile.sql`

Then inspect the canonical staging definitions:

7. `sql/staging/10_stg_events.sql`
8. `sql/staging/11_stg_items.sql`

## What must be recorded before Step 3

- observed min/max event date
- observed day count
- event row count
- distinct pseudonymous users
- event vocabulary
- coverage of session-related parameters
- ecommerce/transaction coverage
- important null/placeholder dimensions

Those observations are intentionally not invented in the repository. They become evidence only after the queries are executed.

## Acceptance criteria

Step 2 is complete when the public source is locked, source limitations are documented, event/item grains are explicit, cost-bounded profiling SQL exists, reusable staging SQL exists, and the repository does not claim unexecuted profiling results as facts.

Step 3 will turn observed profiling outputs into executable data-quality gates.
