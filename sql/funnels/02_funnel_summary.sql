-- Ordered funnel summary with entry sessions preserved through every stage.
WITH e AS (
  SELECT user_pseudo_id,
    (SELECT value.int_value FROM UNNEST(event_params) WHERE key='ga_session_id' LIMIT 1) ga_session_id,
    TIMESTAMP_MICROS(event_timestamp) event_ts,event_name
  FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
  WHERE _TABLE_SUFFIX BETWEEN '20201101' AND '20210131'
), a AS (
  SELECT user_pseudo_id,ga_session_id,MIN(event_ts) t1 FROM e
  WHERE user_pseudo_id IS NOT NULL AND ga_session_id IS NOT NULL AND event_name='session_start' GROUP BY 1,2
), b AS (
  SELECT a.*,MIN(IF(e.event_name='view_item' AND e.event_ts>=a.t1,e.event_ts,NULL)) t2
  FROM a LEFT JOIN e USING(user_pseudo_id,ga_session_id) GROUP BY 1,2,3
), c AS (
  SELECT b.*,MIN(IF(e.event_name='add_to_cart' AND b.t2 IS NOT NULL AND e.event_ts>=b.t2,e.event_ts,NULL)) t3
  FROM b LEFT JOIN e USING(user_pseudo_id,ga_session_id) GROUP BY 1,2,3,4
), d AS (
  SELECT c.*,MIN(IF(e.event_name='begin_checkout' AND c.t3 IS NOT NULL AND e.event_ts>=c.t3,e.event_ts,NULL)) t4
  FROM c LEFT JOIN e USING(user_pseudo_id,ga_session_id) GROUP BY 1,2,3,4,5
), f AS (
  SELECT d.*,MIN(IF(e.event_name='purchase' AND d.t4 IS NOT NULL AND e.event_ts>=d.t4,e.event_ts,NULL)) t5
  FROM d LEFT JOIN e USING(user_pseudo_id,ga_session_id) GROUP BY 1,2,3,4,5,6
), counts AS (
  SELECT COUNT(*) s1,COUNTIF(t2 IS NOT NULL) s2,COUNTIF(t3 IS NOT NULL) s3,
         COUNTIF(t4 IS NOT NULL) s4,COUNTIF(t5 IS NOT NULL) s5 FROM f
)
SELECT 1 stage,'session_start' stage_name,s1 sessions,NULL step_conversion_rate,1.0 overall_conversion_rate,NULL dropoff_sessions FROM counts
UNION ALL SELECT 2,'view_item',s2,SAFE_DIVIDE(s2,s1),SAFE_DIVIDE(s2,s1),s1-s2 FROM counts
UNION ALL SELECT 3,'add_to_cart',s3,SAFE_DIVIDE(s3,s2),SAFE_DIVIDE(s3,s1),s2-s3 FROM counts
UNION ALL SELECT 4,'begin_checkout',s4,SAFE_DIVIDE(s4,s3),SAFE_DIVIDE(s4,s1),s3-s4 FROM counts
UNION ALL SELECT 5,'purchase',s5,SAFE_DIVIDE(s5,s4),SAFE_DIVIDE(s5,s1),s4-s5 FROM counts
ORDER BY stage;
