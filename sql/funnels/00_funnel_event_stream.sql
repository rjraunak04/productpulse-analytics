-- Eligible ordered event stream for the canonical ecommerce session funnel.
SELECT
  user_pseudo_id,
  (SELECT value.int_value FROM UNNEST(event_params)
   WHERE key='ga_session_id' LIMIT 1) AS ga_session_id,
  TIMESTAMP_MICROS(event_timestamp) AS event_ts,
  event_name,
  event_bundle_sequence_id,
  batch_event_index,
  device.category AS device_category,
  geo.country,
  traffic_source.source AS first_user_source,
  traffic_source.medium AS first_user_medium
FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
WHERE _TABLE_SUFFIX BETWEEN '20201101' AND '20210131'
  AND user_pseudo_id IS NOT NULL
  AND (SELECT value.int_value FROM UNNEST(event_params)
       WHERE key='ga_session_id' LIMIT 1) IS NOT NULL
  AND event_name IN ('session_start','view_item','add_to_cart','begin_checkout','purchase');
