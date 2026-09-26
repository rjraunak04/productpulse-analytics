-- Session invariants. Any non-zero violation count requires investigation.
WITH sessions AS (
  WITH e AS (
    SELECT
      user_pseudo_id,
      (SELECT value.int_value FROM UNNEST(event_params)
       WHERE key='ga_session_id' LIMIT 1) AS ga_session_id,
      TIMESTAMP_MICROS(event_timestamp) AS event_ts
    FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
    WHERE _TABLE_SUFFIX BETWEEN '20201101' AND '20210131'
  )
  SELECT user_pseudo_id,ga_session_id,MIN(event_ts) start_ts,MAX(event_ts) end_ts,COUNT(*) event_count
  FROM e
  WHERE user_pseudo_id IS NOT NULL AND ga_session_id IS NOT NULL
  GROUP BY 1,2
)
SELECT
  COUNT(*) AS sessions,
  COUNTIF(start_ts>end_ts) AS inverted_time_sessions,
  COUNTIF(event_count<=0) AS nonpositive_event_sessions,
  COUNT(*)-COUNT(DISTINCT CONCAT(user_pseudo_id,'|',CAST(ga_session_id AS STRING)))
    AS duplicate_session_keys
FROM sessions;
