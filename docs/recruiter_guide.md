# Recruiter guide

## 60-second summary

ProductPulse is an end-to-end product analytics system built around Google's public GA4 ecommerce sample. It turns raw event data into governed behavioural grains, product KPIs, an ordered conversion funnel, cohort retention, experimentation utilities, customer-value analysis, survival/time-to-return analysis and a lightweight decision application.

The project emphasizes metric correctness and decision quality rather than dashboard volume.

## What to inspect first

1. `README.md` — project story and architecture
2. `sql/` — analytics engineering and advanced SQL
3. `src/productpulse/` + `tests/` — reusable tested statistical/metric logic
4. `docs/` — metric definitions and interpretation boundaries
5. `app/streamlit_app.py` — decision-facing presentation

## Skills demonstrated

**Product analytics:** North Star design, funnels, cohorts, retention, lifecycle states and growth accounting.

**Analytics engineering:** explicit grains, contracts, reconciliation checks, safe ratios and bounded source queries.

**Statistics:** confidence intervals, hypothesis tests, SRM, MDE/power planning and Kaplan–Meier estimation.

**Business analytics:** monetization, repeat purchase, acquisition-source context and RFM-style segmentation.

**Engineering:** Python package structure, tests, linting, CI, configuration-driven contracts and Streamlit.

## Important integrity choices

The repository does not pretend that first observed activity is signup, inactivity is permanent churn, observed revenue is LTV, first-user source is session attribution, or simulated A/B assignment is a real randomized experiment.

Those boundaries are part of the project, not missing features.
