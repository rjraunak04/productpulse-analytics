# ProductPulse Analytics

An end-to-end product growth and experimentation analytics project built around event-level behavioural data.

ProductPulse is designed to answer the questions a product or growth analytics team faces every day: where users drop from the journey, what drives activation and retention, whether a product change creates measurable lift, and how user behaviour connects to commercial outcomes.

## Project goals

- Build product metrics from raw event data rather than a pre-aggregated dashboard dataset.
- Analyse acquisition, activation, engagement, conversion, retention and monetisation.
- Build reusable funnel and cohort analysis.
- Demonstrate statistically sound A/B experimentation.
- Connect behavioural metrics with unit economics.
- Keep the analysis reproducible, tested and easy for another analyst to review.

## Planned data source

The analytical foundation will use the public Google Analytics 4 sample ecommerce event dataset in BigQuery. Experiment assignments used for the experimentation module will be explicitly documented as simulated where a real randomized assignment is unavailable.

No raw production-like dataset is committed to this repository.

## Analytical workflow

Raw events -> data quality -> sessions/users -> metric layer -> funnels -> cohorts/retention -> experimentation -> unit economics -> churn/survival -> decision application.

## Repository structure

- `configs/` - project and metric configuration
- `docs/` - business context, metrics and architecture documentation
- `sql/` - BigQuery transformations and analytical queries
- `src/productpulse/` - reusable Python analytics package
- `tests/` - automated tests
- `app/` - decision-oriented analytical application
- `reports/` - generated analytical outputs
- `assets/` - recruiter-facing screenshots and diagrams

## Current status

**Step 11 complete — recruiter-ready decision application.**

ProductPulse now includes a lightweight Streamlit decision workspace spanning the North Star, ordered funnel, cohort retention, experimentation, observed economics and inactivity analysis. The UI consumes validated aggregate exports, preserves analytical caveats in-context, and intentionally shows safe empty states instead of fabricated portfolio results when BigQuery outputs have not been executed/exported.

## Roadmap

1. Project foundation and business case
2. GA4 BigQuery data foundation
3. Event-level data quality
4. User/session behavioural layer
5. Product KPI framework
6. Conversion funnel engine
7. Cohort and retention engine
8. Statistical experimentation framework
9. Growth and unit economics
10. Churn and survival analytics
11. Decision application
12. Production hardening and recruiter release

## Principles

Reproducibility over screenshots. Business decisions over vanity metrics. Statistical and practical significance are reported separately. Associations are not described as causal without an appropriate design.

---
Built as a portfolio-grade analytics project focused on product, growth and experimentation skills.
