# ProductPulse

**Product growth, experimentation and customer-behaviour analytics from raw GA4 events to decisions — with a grounded conversational Analytics Copilot.**

**Live demo:** https://productpulse-app-production.up.railway.app

ProductPulse is an end-to-end analytics portfolio project built on Google's public GA4 ecommerce sample in BigQuery. It demonstrates how a product/data analyst can move from event-level data contracts to trustworthy metrics, statistical analysis and a decision-facing application without hiding important measurement limitations.

## Recruiter quick start

1. Open the **live demo** and review Executive Overview → Funnel → Retention → Analytics Copilot.
2. Read **[Validated Live Execution](docs/live_execution.md)** for the real execution snapshot and analytical boundaries.
3. Review `sql/` for warehouse logic, `src/productpulse/` for reusable analytics/statistics, and `tests/` + GitHub Actions for quality gates.
4. The Analytics Copilot is intentionally **grounded and bounded**: it answers from committed validated aggregates and refuses unsupported topics instead of inventing metrics.

## What this project answers

- Is meaningful weekly product activity growing?
- Where do users drop in an **ordered** product journey?
- Which cohorts return, and how does retention change over time?
- How should an A/B experiment be validated and interpreted?
- Where is observed customer value concentrated?
- How long does it take users to return after activity?

## Validated production snapshot

| Metric | Result |
| --- | ---: |
| Raw GA4 events | **4,295,584** |
| Pseudonymous users | **270,154** |
| Raw purchase events | **5,692** |
| Ordered funnel | **354,857 → 75,261 → 14,891 → 5,325 → 2,802** |
| Analysis window | **2020-11-01 → 2021-01-31** |

The ordered funnel represents session-level progression through `session_start → view_item → add_to_cart → begin_checkout → purchase`. Raw purchase events and ordered purchase sessions are different grains and are intentionally not equated. See **[Validated Live Execution](docs/live_execution.md)** for the execution contract and interpretation boundaries.

## Architecture

```text
GA4 public BigQuery sample
        ↓
Source contracts + staging
        ↓
Data-quality gates
        ↓
Event / session / user behavioural grains
        ↓
Product KPIs + North Star
        ↓
Ordered funnel ─ Cohorts/retention ─ Experimentation
        ↓                  ↓                 ↓
Growth economics      Survival analysis   Statistical decisions
        \__________________|________________/
                           ↓
                  Streamlit decision app
```

## Analytics layers

| Layer | What is implemented |
| --- | --- |
| Data foundation | bounded GA4 queries, schema/source contracts, staging |
| Quality | completeness, identity/session coverage, purchase/item integrity, invariants |
| Behaviour | event, session, user, user-day and ordered event-sequence grains |
| Product metrics | Weekly Activated Users v1, WAU, activation and engagement context |
| Funnel | `session_start → view_item → add_to_cart → begin_checkout → purchase` |
| Retention | first-observed cohorts, W0-W8 matrix, retained/resurrected states, growth accounting |
| Experimentation | deterministic simulated assignment, SRM, uplift, CI, p-value, practical significance, power/MDE |
| Economics | observed revenue/value, repeat purchase, acquisition-source context, RFM-style segmentation |
| Survival | right-censored time-to-next-activity and Kaplan–Meier estimation |
| Decision app | focused Streamlit views over validated aggregate exports |
| Analytics Copilot | grounded chat over validated KPIs, funnel, retention, experiment, economics and inactivity outputs |

## Technical stack

**BigQuery SQL · Advanced SQL · Python · pandas · SciPy/Statsmodels · statistics · conversational analytics · pytest · Ruff · GitHub Actions · Streamlit · Railway**

The Python package contains reusable metric, funnel, retention, experimentation, economics and survival helpers. SQL owns warehouse metric logic; Python handles reusable statistical/validation semantics; Streamlit stays a thin presentation layer.

## Run locally

```bash
python -m venv .venv
# activate the environment
pip install -e ".[dev]"
ruff check src tests
pytest -q

pip install -r requirements-app.txt
streamlit run app/streamlit_app.py
```

The app expects validated aggregate CSV exports in `reports/app_data/`. If they are absent, it intentionally shows safe empty states rather than invented KPI values.

## Data and analytical integrity

The source is `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`, bounded to **2020-11-01 through 2021-01-31**. No raw GA4 data or credentials are committed.

Important boundaries:

- `user_pseudo_id` is a pseudonymous client identifier, not a verified person.
- first observed activity inside the sample is not claimed to be signup.
- top-level GA4 traffic source is first-user context, not session attribution.
- missing future cohort follow-up is unobservable, not 0% retention.
- inactivity/right censoring is not automatically permanent churn.
- observed-window revenue is not lifetime value.
- CAC, ROAS and payback are not fabricated without cost data.
- the experiment assignment is **simulated for framework demonstration**; it is not a real randomized Google Merchandise Store experiment and does not establish a causal product effect.

## Repository map

```text
app/                    Streamlit decision layer
configs/                versioned analytics contracts
docs/                   methodology, runbooks and recruiter narrative
reports/app_data/       validated aggregate export interface
sql/
  staging/              source profiling and staging
  quality/              quality and invariant checks
  behavioural/          reusable behavioural grains
  product_metrics/      KPI and North Star layer
  funnels/              ordered conversion analysis
  retention/            cohorts and lifecycle analysis
  experimentation/      experiment demonstration inputs
  economics/            monetization/value analysis
  survival/             time-to-return/censoring analysis
src/productpulse/       tested Python analytics utilities
tests/                  unit tests
.github/workflows/      CI quality gate
```

## Recruiter walkthrough

For a fast review, start with **[Recruiter Guide](docs/recruiter_guide.md)**, **[Validated Live Execution](docs/live_execution.md)** and **[Interview Story](docs/interview_story.md)**. The full v1 scope is recorded in **[v1 Acceptance](docs/v1_acceptance.md)** and **[Changelog](CHANGELOG.md)**.

## Status

**v1.0.0 scope complete — feature frozen.**

The analytical system has been executed against the public GA4 sample, its six aggregate app outputs have been validated and committed, and the Streamlit decision application is deployed on Railway. The v1 portfolio scope is frozen; future changes should address real requirements or defects rather than add showcase features.
