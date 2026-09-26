# Cohort and retention engine

## Cohort definition

A user's cohort is their **first observed active week inside the public sample**. This is intentionally not called signup cohort because the source window may begin after a user's true first-ever interaction.

## Retention definition

ProductPulse v1 uses **classic weekly retention**:

> Of users first observed in cohort week W0, what fraction were active in exactly W+n?

Any observed event counts as activity in v1. Week 0 must equal 100% by construction.

## Right censoring

Later cohorts have less opportunity to demonstrate long-term retention. Missing W+n values beyond the observation window are **unobservable**, not zero retention and not churn.

The follow-up query reports the maximum observable week for each cohort.

## Lifecycle states

For observed active weeks:

- **new_observed** — user's first observed week
- **retained** — active in the immediately previous week
- **resurrected** — active now after at least one inactive week

A separate weekly growth-accounting query also counts users who were active in the prior week but are not active now as **newly inactive**. This is an observed activity state, not proof of permanent customer churn.

## Matrix

A W0-W8 matrix is provided for concise analysis. NULL cells in later cohorts can represent unavailable follow-up and must not be rendered as 0%.

## Identity boundary

Retention is based on `user_pseudo_id`, so it describes pseudonymous client identifiers, not verified individuals across all devices.

## Interpretation

Cohort differences are descriptive. Acquisition mix, calendar effects, product changes and censoring can all contribute to observed differences.
