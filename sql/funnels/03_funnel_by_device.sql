-- Segmented funnel entry and final ordered conversion by device.
-- Device is taken from the session_start event to avoid segment drift within a session.
WITH e AS (
  SELECT user_pseudo_id,
    (SELECT value.int_value FROM UNNEST(event_params) WHERE key='ga_session_id' LIMIT 1) ga_session_id,
    TIMESTAMP_MICROS(event_timestamp) event_ts,event_name,device.category device_category
  FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
  WHERE _TABLE_SUFFIX BETWEEN '20201101' AND '20210131'
),
start AS (
  SELECT user_pseudo_id,ga_session_id,
    ARRAY_AGG(STRUCT(event_ts,device_category) ORDER BY event_ts LIMIT 1)[OFFSET(0)] start_record
  FROM e WHERE user_pseudo_id IS NOT NULL AND ga_session_id IS NOT NULL AND event_name='session_start' GROUP BY 1,2
),
f AS (
  SELECT s.user_pseudo_id,s.ga_session_id,s.start_record.device_category,
    MIN(IF(e.event_name='view_item' AND e.event_ts>=s.start_record.event_ts,e.event_ts,NULL)) t2
  FROM start s LEFT JOIN e USING(user_pseudo_id,ga_session_id) GROUP BY 1,2,3
),
f3 AS (
  SELECT f.*,MIN(IF(e.event_name='add_to_cart' AND e.event_ts>=f.t2,e.event_ts,NULL)) t3
  FROM f LEFT JOIN e USING(user_pseudo_id,ga_session_id) GROUP BY 1,2,3,4
),
f4 AS (
  SELECT f3.*,MIN(IF(e.event_name='begin_checkout' AND e.event_ts>=f3.t3,e.event_ts,NULL)) t4
  FROM f3 LEFT JOIN e USING(user_pseudo_id,ga_session_id) GROUP BY 1,2,3,4,5
),
f5 AS (
  SELECT f4.*,MIN(IF(e.event_name='purchase' AND e.event_ts>=f4.t4,e.event_ts,NULL)) t5
  FROM f4 LEFT JOIN e USING(user_pseudo_id,ga_session_id) GROUP BY 1,2,3,4,5,6
)
SELECT COALESCE(device_category,'(not set)') device_category,
  COUNT(*) funnel_entry_sessions,
  COUNTIF(t5 IS NOT NULL) completed_funnel_sessions,
  SAFE_DIVIDE(COUNTIF(t5 IS NOT NULL),COUNT(*)) ordered_funnel_conversion_rate
FROM f5 GROUP BY 1 ORDER BY funnel_entry_sessions DESC;
