# Validated live execution

ProductPulse was executed against Google's public GA4 BigQuery ecommerce sample for **2020-11-01 through 2021-01-31**. The application consumes validated aggregate exports rather than querying BigQuery on every interaction.

## Source validation

| Check | Validated result |
| --- | ---: |
| Raw events | 4,295,584 |
| Pseudonymous users | 270,154 |
| Raw purchase events | 5,692 |
| Source date range | 2020-11-01 → 2021-01-31 |

## Ordered conversion funnel

| Stage | Sessions |
| --- | ---: |
| session_start | 354,857 |
| view_item | 75,261 |
| add_to_cart | 14,891 |
| begin_checkout | 5,325 |
| purchase | 2,802 |

The 5,692 source purchase events and 2,802 funnel purchases are intentionally different measures: the former counts raw purchase events; the latter counts sessions that reached purchase after satisfying the complete ordered same-session path.

## Export contract

The six validated app inputs are committed under `reports/app_data/`: weekly product KPIs, funnel summary, retention matrix, experiment summary, weekly revenue metrics and inactivity summary. Validation confirmed non-empty outputs, expected schemas, no null cells, monotonic funnel reach, W0 retention of 100%, experiment variant/non-causal markers and inactivity shares summing to approximately 1.

## Interpretation boundaries

Retention cohorts represent first **observed** active week, not signup cohorts. Future cohort cells can be right-censored. Boundary calendar weeks are partial. Experiment assignment is deterministic and simulated; observed outcomes are real sample outcomes, but variant differences are **not causal**. Inactivity states are observed-window states, not permanent churn. `user_pseudo_id` is a pseudonymous client identifier, not a verified customer identity.
