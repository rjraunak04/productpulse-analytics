# Interview story

## 3-minute version

**Problem:** Product teams can have millions of event rows but still struggle to answer basic questions consistently: what meaningful activity is growing, where users drop, whether they return, whether a change improved outcomes, and where value is concentrated.

**Data foundation:** I used Google's public GA4 ecommerce sample in BigQuery. Before metrics, I defined source contracts, bounded wildcard queries, explicit event/session/user grains and data-quality checks.

**Measurement:** I built a weekly North Star and supporting KPIs, then an ordered same-session funnel so event presence could not masquerade as journey conversion.

**Retention:** I assigned first-observed weekly cohorts, built classic weekly retention and lifecycle states, and handled right censoring rather than turning unavailable future weeks into zero retention.

**Experimentation:** Because the public data has no verified randomized assignment, I built a clearly disclosed deterministic simulated assignment layer to demonstrate SRM, uplift, confidence intervals, hypothesis testing, practical significance and power/MDE planning without making causal claims.

**Economics and survival:** I measured observed revenue/value, repeat purchase and RFM-style segments without fabricating CAC/LTV. I also modeled time to next activity with censoring and a tested Kaplan–Meier estimator.

**Decision layer:** Finally, I exposed validated aggregates through a lightweight Streamlit app. SQL remains the metric source of truth and the app preserves caveats rather than duplicating metric logic.

## Deep-dive prompts

Be ready to explain:

- why `user_pseudo_id + ga_session_id` is the session key
- why funnel ordering matters
- why first observed week is not signup
- why missing retention follow-up is not 0%
- SRM before experiment interpretation
- statistical vs practical significance
- why observed value is not LTV
- what right censoring means
- why the app uses aggregate exports rather than raw warehouse queries
