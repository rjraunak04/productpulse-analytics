-- Session-based weekly KPIs. Session week is anchored to first observed event.
WITH events AS (
  SELECT
    user_pseudo_id,
    (SELECT value.int_value FROM UNNEST(event_params)
     WHERE key='ga_session_id' LIMIT 1) AS ga_session_id,
    TIMESTAMP_MICROS(event_timestamp) AS event_ts,
    event_name
  FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
  WHERE _TABLE_SUFFIX BETWEEN '20201101' AND '20210131'
),
sessions AS (
  SELECT
    user_pseudo_id,
    ga_session_id,
    DATE_TRUNC(DATE(MIN(event_ts)),WEEK(MONDAY)) AS week_start,
    COUNTIF(event_name='purchase')>0 AS purchased
  FROM events
  WHERE user_pseudo_id IS NOT NULL AND ga_session_id IS NOT NULL
  GROUP BY 1,2
)
SELECT
  week_start,
  COUNT(*) AS observed_sessions,
  COUNTIF(purchased) AS purchasing_sessions,
  SAFE_DIVIDE(COUNTIF(purchased),COUNT(*)) AS purchase_session_rate
FROM sessions
GROUP BY week_start
ORDER BY week_start;
