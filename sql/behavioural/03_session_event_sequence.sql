-- Ordered event sequence for journey diagnostics.
-- Grain: session + event position.
WITH events AS (
  SELECT
    user_pseudo_id,
    (SELECT value.int_value FROM UNNEST(event_params)
     WHERE key='ga_session_id' LIMIT 1) AS ga_session_id,
    TIMESTAMP_MICROS(event_timestamp) AS event_ts,
    event_name,
    event_bundle_sequence_id,
    batch_event_index
  FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
  WHERE _TABLE_SUFFIX BETWEEN '20201101' AND '20210131'
)
SELECT
  user_pseudo_id,
  ga_session_id,
  ROW_NUMBER() OVER(
    PARTITION BY user_pseudo_id,ga_session_id
    ORDER BY event_ts,event_bundle_sequence_id,batch_event_index,event_name
  ) AS event_position,
  event_ts,
  event_name,
  LAG(event_name) OVER(
    PARTITION BY user_pseudo_id,ga_session_id
    ORDER BY event_ts,event_bundle_sequence_id,batch_event_index,event_name
  ) AS previous_event_name,
  LEAD(event_name) OVER(
    PARTITION BY user_pseudo_id,ga_session_id
    ORDER BY event_ts,event_bundle_sequence_id,batch_event_index,event_name
  ) AS next_event_name
FROM events
WHERE user_pseudo_id IS NOT NULL AND ga_session_id IS NOT NULL;
