# Changelog

## v1.0.0 — 2026-09-26

First portfolio release of ProductPulse.

### Included

- GA4 BigQuery source/staging contracts
- event-level quality gates
- reusable event/session/user behavioural grains
- product KPI and North Star layer
- ordered same-session conversion funnel
- cohort retention and lifecycle analytics
- statistical experimentation framework with explicit simulated assignment
- observed growth/customer economics
- censoring-aware inactivity and survival analytics
- Streamlit decision application
- Python unit tests, Ruff linting and GitHub Actions quality gate

### Data integrity boundaries

No fabricated warehouse outputs are shipped. The public GA4 sample is bounded and obfuscated; identity is pseudonymous. Experiment assignment is simulated for framework demonstration. Unsupported CAC/ROAS/profit-LTV metrics are intentionally excluded.
