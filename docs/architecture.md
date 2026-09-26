# Architecture

## Logical flow

1. **Source** — public GA4 BigQuery sample event data.
2. **Staging** — selected fields, normalized timestamps and documented event semantics.
3. **Quality** — duplicate, identifier, timestamp, event and referential checks.
4. **Behavioural layer** — reusable user/session/event grains.
5. **Metric layer** — activation, engagement, conversion and monetisation definitions.
6. **Analytics** — funnels, cohorts, retention, experimentation, economics and survival.
7. **Decision layer** — compact analytical application and generated reports.
8. **Quality gate** — automated tests and CI before stable releases.

## Design boundaries

BigQuery/SQL performs event transformation and scalable behavioural aggregation. Python handles statistical analysis, reusable analytical components and validation that is clearer outside SQL. The final application communicates decisions rather than duplicating warehouse logic.

## Reproducibility

Raw public data is referenced, not committed. Queries and configuration define transformations. Experiment simulation uses a fixed seed and documented assumptions. Generated artefacts must be reproducible from version-controlled code.
