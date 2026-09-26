-- Ordered same-session funnel.
-- Each stage timestamp is searched only after the previously reached stage.
WITH e AS (
  SELECT
    user_pseudo_id,
    (SELECT value.int_value FROM UNNEST(event_params)
     WHERE key='ga_session_id' LIMIT 1) AS ga_session_id,
    TIMESTAMP_MICROS(event_timestamp) AS event_ts,
    event_name
  FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
  WHERE _TABLE_SUFFIX BETWEEN '20201101' AND '20210131'
),
s1 AS (
  SELECT user_pseudo_id,ga_session_id,MIN(event_ts) AS session_start_ts
  FROM e
  WHERE user_pseudo_id IS NOT NULL AND ga_session_id IS NOT NULL AND event_name='session_start'
  GROUP BY 1,2
),
s2 AS (
  SELECT s1.*,MIN(e.event_ts) AS view_item_ts
  FROM s1 LEFT JOIN e USING(user_pseudo_id,ga_session_id)
  WHERE e.event_name='view_item' AND e.event_ts>=s1.session_start_ts
  GROUP BY 1,2,3
),
s3 AS (
  SELECT s2.*,MIN(e.event_ts) AS add_to_cart_ts
  FROM s2 LEFT JOIN e USING(user_pseudo_id,ga_session_id)
  WHERE e.event_name='add_to_cart' AND e.event_ts>=s2.view_item_ts
  GROUP BY 1,2,3,4
),
s4 AS (
  SELECT s3.*,MIN(e.event_ts) AS begin_checkout_ts
  FROM s3 LEFT JOIN e USING(user_pseudo_id,ga_session_id)
  WHERE e.event_name='begin_checkout' AND e.event_ts>=s3.add_to_cart_ts
  GROUP BY 1,2,3,4,5
),
s5 AS (
  SELECT s4.*,MIN(e.event_ts) AS purchase_ts
  FROM s4 LEFT JOIN e USING(user_pseudo_id,ga_session_id)
  WHERE e.event_name='purchase' AND e.event_ts>=s4.begin_checkout_ts
  GROUP BY 1,2,3,4,5,6
)
SELECT * FROM s5;
