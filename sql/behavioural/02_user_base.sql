-- User behavioural layer.
-- Grain: user_pseudo_id across the contracted observation window.
WITH sessions AS (
  -- Mirrors the session aggregation contract. Kept self-contained for reproducibility.
  WITH events AS (
    SELECT
      TIMESTAMP_MICROS(event_timestamp) AS event_ts,
      event_name,
      user_pseudo_id,
      ecommerce.purchase_revenue_in_usd,
      (SELECT value.int_value FROM UNNEST(event_params)
       WHERE key='ga_session_id' LIMIT 1) AS ga_session_id
    FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
    WHERE _TABLE_SUFFIX BETWEEN '20201101' AND '20210131'
  )
  SELECT
    user_pseudo_id,
    ga_session_id,
    MIN(event_ts) AS session_start_ts,
    MAX(event_ts) AS session_end_ts,
    COUNT(*) AS event_count,
    COUNTIF(event_name='view_item') > 0 AS viewed_item,
    COUNTIF(event_name='add_to_cart') > 0 AS added_to_cart,
    COUNTIF(event_name='begin_checkout') > 0 AS began_checkout,
    COUNTIF(event_name='purchase') > 0 AS purchased,
    SUM(IF(event_name='purchase',COALESCE(purchase_revenue_in_usd,0),0)) AS revenue_usd
  FROM events
  WHERE user_pseudo_id IS NOT NULL AND ga_session_id IS NOT NULL
  GROUP BY user_pseudo_id,ga_session_id
)
SELECT
  user_pseudo_id,
  MIN(session_start_ts) AS first_observed_session_ts,
  MAX(session_end_ts) AS last_observed_session_ts,
  COUNT(*) AS observed_sessions,
  SUM(event_count) AS observed_events_in_sessionized_data,
  COUNTIF(viewed_item) AS sessions_with_item_view,
  COUNTIF(added_to_cart) AS sessions_with_add_to_cart,
  COUNTIF(began_checkout) AS sessions_with_checkout,
  COUNTIF(purchased) AS purchasing_sessions,
  SUM(revenue_usd) AS observed_purchase_revenue_usd,
  TIMESTAMP_DIFF(MAX(session_end_ts),MIN(session_start_ts),DAY) AS observed_span_days
FROM sessions
GROUP BY user_pseudo_id;
