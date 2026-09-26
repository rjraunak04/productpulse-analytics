-- Reconciliation between raw eligible events and sessionized events.
WITH events AS (
  SELECT
    user_pseudo_id,
    (SELECT value.int_value FROM UNNEST(event_params)
     WHERE key='ga_session_id' LIMIT 1) AS ga_session_id
  FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
  WHERE _TABLE_SUFFIX BETWEEN '20201101' AND '20210131'
)
SELECT
  COUNT(*) AS all_events,
  COUNTIF(user_pseudo_id IS NOT NULL AND ga_session_id IS NOT NULL) AS sessionizable_events,
  COUNTIF(user_pseudo_id IS NULL OR ga_session_id IS NULL) AS excluded_from_session_layer,
  SAFE_DIVIDE(
    COUNTIF(user_pseudo_id IS NOT NULL AND ga_session_id IS NOT NULL),COUNT(*)
  ) AS sessionizable_event_rate
FROM events;
