# ProductPulse decision application

## Purpose

The app is a thin decision layer over the analytical system, not a second analytics implementation. SQL remains the source of metric truth; the UI consumes validated aggregate exports.

This design keeps metric definitions reviewable, avoids expensive warehouse queries on every interaction and makes the portfolio experience reproducible.

## Views

### Executive overview
North Star and weekly activity context. The purpose is to establish whether meaningful product activity is changing before drilling into diagnostics.

### Funnel
Ordered same-session conversion and drop-off. Presence flags are not substituted for ordered progression.

### Retention
Weekly cohort matrix with censoring-aware interpretation. Unobservable future cells remain missing rather than zero.

### Experimentation
A clearly disclosed demonstration of the statistical framework. Assignment is simulated and must never be presented as a real randomized Google Merchandise Store experiment.

### Economics
Observed-window monetization/value. The app does not display fabricated CAC, ROAS, payback or lifetime value.

### Inactivity
Endpoint inactivity and time-to-return context. Inactive/censored users are not automatically called churned.

## Decision flow

The intended recruiter/product-manager walkthrough is:

1. Is the North Star moving?
2. Where does the ordered journey lose users?
3. Do users return after initial activity?
4. If a product change is tested, is assignment valid and is uplift both statistically and practically meaningful?
5. Is observed value concentrated in particular behavioural/acquisition groups?
6. How quickly do users return, and where does inactivity accumulate?

## Data contract

The app reads small aggregate CSV files from `reports/app_data/`. Raw GA4 data and credentials are excluded from Git.

The empty-state experience is intentional: if validated query outputs have not been exported, the UI says so rather than inventing demo KPI values.
