-- Canonical behavioural event view.
-- Grain: one GA4 event. No repeated arrays are expanded.
SELECT
  PARSE_DATE('%Y%m%d', event_date) AS event_date,
  TIMESTAMP_MICROS(event_timestamp) AS event_ts,
  event_name,
  user_pseudo_id,
  platform,
  device.category AS device_category,
  geo.country,
  traffic_source.source AS first_user_source,
  traffic_source.medium AS first_user_medium,
  ecommerce.transaction_id,
  ecommerce.purchase_revenue_in_usd,
  (SELECT value.int_value FROM UNNEST(event_params)
   WHERE key='ga_session_id' LIMIT 1) AS ga_session_id,
  (SELECT value.int_value FROM UNNEST(event_params)
   WHERE key='ga_session_number' LIMIT 1) AS ga_session_number
FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
WHERE _TABLE_SUFFIX BETWEEN '20201101' AND '20210131';
