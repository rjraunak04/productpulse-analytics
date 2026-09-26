-- Session layer.
-- Grain: user_pseudo_id + ga_session_id.
-- Rows without either component are excluded and must remain visible in Step 3 coverage diagnostics.
WITH events AS (
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
    ecommerce.purchase_revenue_in_usd,
    (SELECT value.int_value FROM UNNEST(event_params)
     WHERE key='ga_session_id' LIMIT 1) AS ga_session_id,
    (SELECT value.int_value FROM UNNEST(event_params)
     WHERE key='ga_session_number' LIMIT 1) AS ga_session_number
  FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
  WHERE _TABLE_SUFFIX BETWEEN '20201101' AND '20210131'
),
valid AS (
  SELECT * FROM events
  WHERE user_pseudo_id IS NOT NULL AND ga_session_id IS NOT NULL
)
SELECT
  user_pseudo_id,
  ga_session_id,
  MIN(event_ts) AS session_start_ts,
  MAX(event_ts) AS session_end_ts,
  TIMESTAMP_DIFF(MAX(event_ts),MIN(event_ts),SECOND) AS observed_session_duration_seconds,
  COUNT(*) AS event_count,
  COUNT(DISTINCT event_name) AS distinct_event_types,
  MAX(ga_session_number) AS ga_session_number,
  ARRAY_AGG(platform IGNORE NULLS ORDER BY event_ts LIMIT 1)[SAFE_OFFSET(0)] AS platform,
  ARRAY_AGG(device_category IGNORE NULLS ORDER BY event_ts LIMIT 1)[SAFE_OFFSET(0)] AS device_category,
  ARRAY_AGG(country IGNORE NULLS ORDER BY event_ts LIMIT 1)[SAFE_OFFSET(0)] AS country,
  ARRAY_AGG(first_user_source IGNORE NULLS ORDER BY event_ts LIMIT 1)[SAFE_OFFSET(0)] AS first_user_source,
  ARRAY_AGG(first_user_medium IGNORE NULLS ORDER BY event_ts LIMIT 1)[SAFE_OFFSET(0)] AS first_user_medium,
  COUNTIF(event_name='view_item') > 0 AS viewed_item,
  COUNTIF(event_name='add_to_cart') > 0 AS added_to_cart,
  COUNTIF(event_name='begin_checkout') > 0 AS began_checkout,
  COUNTIF(event_name='purchase') > 0 AS purchased,
  COUNTIF(event_name='purchase') AS purchase_event_count,
  SUM(IF(event_name='purchase',COALESCE(purchase_revenue_in_usd,0),0)) AS purchase_revenue_usd
FROM valid
GROUP BY user_pseudo_id,ga_session_id;
