# Data-quality framework

Step 3 separates **source observations** from **quality policy**.

The SQL diagnostics measure the GA4 public sample. The YAML contract describes how observations should be interpreted. Small Python evaluators produce deterministic PASS/FAIL records and CI validates the reusable code.

## Why warnings exist

A public, obfuscated analytics export can contain missing identifiers, attribution gaps or unusual records without being unusable. ProductPulse therefore does not declare every non-zero diagnostic a data error.

- **error** — violates a condition required for a downstream metric and blocks release.
- **warn** — must be measured and explained before the affected metric is used.

## Quality dimensions

**Completeness:** required dates/timestamps/event names, pseudonymous-user and session coverage.

**Uniqueness:** candidate duplicate events and repeated transaction IDs.

**Validity:** contract date range, non-negative purchase values and required journey events.

**Continuity:** expected calendar coverage and day-over-day event volume diagnostics.

**Integrity:** purchase transaction/revenue fields and item-level identifiers/values.

## Duplicate policy

There is no invented universal GA4 event primary key. Candidate duplicates are measured from a conservative composite of timestamp, event name, pseudonymous user and bundle/batch metadata. A flagged record is investigated; it is not automatically deleted.

## Timestamp policy

`event_date` and the UTC date derived from `event_timestamp` may differ because their semantics are not identical. The repository measures the mismatch rather than treating every mismatch as corruption.

## Threshold policy

Hard numeric thresholds are introduced only after observing the public sample or where the contract is logically exact (for example, a required timestamp cannot be null). This prevents arbitrary portfolio-friendly thresholds.

## Step 3 outputs

- `sql/quality/` — reproducible source diagnostics
- `configs/quality_rules.yaml` — explicit severity/expectation contract
- `src/productpulse/quality/` — deterministic result/report utilities
- `tests/test_quality_checks.py` — unit tests
- `.github/workflows/quality.yml` — CI gate

The next step may consume only metrics whose required quality conditions have been validated.
