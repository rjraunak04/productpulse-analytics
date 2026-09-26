# ProductPulse v1 acceptance checklist

## Foundation
- [x] documented public GA4 source and fixed observation window
- [x] bounded wildcard queries
- [x] explicit event, session, user and user-day grains
- [x] data-quality rules and reconciliation queries

## Product analytics
- [x] North Star and supporting KPI contract
- [x] ordered same-session funnel
- [x] cohort retention and lifecycle states
- [x] growth accounting

## Statistics
- [x] SRM, uplift, CI and hypothesis-test utilities
- [x] practical-significance threshold
- [x] power/MDE planning
- [x] censoring-aware time-to-return analysis
- [x] Kaplan–Meier estimator

## Economics
- [x] observed monetization and user value
- [x] repeat-purchase behaviour
- [x] RFM-style segmentation
- [x] unsupported CAC/ROAS/LTV explicitly excluded

## Engineering
- [x] Python package and tests
- [x] Ruff + pytest CI
- [x] configuration contracts
- [x] Streamlit decision app
- [x] safe empty states; no fabricated outputs
- [x] recruiter/interview documentation

## Release boundary

v1 is feature-frozen after release. Future work should be driven by real product requirements or defects, not portfolio feature accumulation.
