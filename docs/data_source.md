# GA4 BigQuery data source

## Source

ProductPulse uses Google's public GA4 ecommerce sample:

`bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`

Google documents this as an obfuscated sample of Google Merchandise Store GA4 BigQuery event export data covering **2020-11-01 through 2021-01-31**.

## Why this source

The project needs event-level behaviour rather than another pre-aggregated sales table. GA4 export data exposes an event grain, pseudonymous user identifier, event parameters, device/geography, traffic-source fields, ecommerce records and repeated item records. That makes the source suitable for later funnel, cohort, retention and product-behaviour work.

## Important schema behaviour

GA4 exports daily `events_YYYYMMDD` tables. Several fields are nested or repeated. In particular, `event_params` and `items` must be handled deliberately because blindly unnesting them multiplies rows.

ProductPulse therefore defines two initial analytical grains:

- **stg_events** — one output row per source event.
- **stg_items** — one output row per event-item.

The event staging query extracts selected event parameters with scalar subqueries so the event grain is preserved.

## Identity

`user_pseudo_id` is the working behavioural identifier. It is treated as a pseudonymous client identifier, not as a known human/customer identity. `user_id` is retained when present but is not assumed to be populated.

## Attribution boundary

The top-level `traffic_source` record describes the traffic source that first acquired the user. ProductPulse will not label it as session-level attribution. Session acquisition will only be implemented if the source fields and profiling support a defensible definition.

## Cost-aware querying

All wildcard source queries use `_TABLE_SUFFIX BETWEEN '20201101' AND '20210131'`. This makes the requested source window explicit and avoids accidental scans outside the sample period.

## Data handling

Raw public event data is not copied into Git. The repository contains SQL, configuration, contracts and documentation needed to reproduce the analysis from the public source.

## Source limitation

Google states that obfuscation can limit internal consistency. ProductPulse will therefore validate observed fields before fixing business metric definitions, and will not force unsupported fields into the analysis.
