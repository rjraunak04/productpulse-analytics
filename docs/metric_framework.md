# Product measurement framework

## North Star

**Weekly Activated Users (WAU-A)**

A user is counted only after satisfying the activation definition configured for the project. The exact event sequence and time window will be finalized after profiling the GA4 event schema in Step 2.

This avoids hard-coding a definition before verifying what the source data can support.

## Metric tree

### Acquisition
- New users
- Sessions by source / medium
- Qualified acquisition rate
- Acquisition-to-activation conversion

### Activation
- Activation rate
- Time to activation
- Onboarding / key-journey completion
- First-value completion

### Engagement
- Active users
- Sessions per active user
- Key-event frequency
- Feature / product interaction depth
- Stickiness where the source supports a defensible definition

### Retention
- N-day / weekly retention
- Cohort retention
- Returning-user rate
- Churn / inactivity
- Resurrection

### Monetisation
- Purchase conversion
- Revenue per user
- Average order value
- Customer value / LTV proxy

### Experimentation
- Primary metric
- Secondary metrics
- Guardrail metrics
- Absolute and relative uplift
- Confidence interval
- Effect size
- Sample-ratio mismatch check
- Power / minimum detectable effect

## Measurement rules

- Every KPI receives a numerator, denominator, grain and time window before production use.
- User, session and event metrics must not be mixed without explicitly changing grain.
- Statistical significance and practical significance are reported separately.
- Retention definitions must state whether they are classic, rolling or unbounded.
- Observational relationships are labelled associations rather than causal effects.
