-- Weekly engagement context. These are supporting metrics, not the North Star.
WITH user_week AS (
  SELECT
    user_pseudo_id,
    DATE_TRUNC(PARSE_DATE('%Y%m%d',event_date),WEEK(MONDAY)) AS week_start,
    COUNT(*) AS event_count,
    COUNT(DISTINCT event_name) AS distinct_event_types,
    COUNTIF(event_name='view_item') AS item_views,
    COUNTIF(event_name='add_to_cart') AS cart_adds
  FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
  WHERE _TABLE_SUFFIX BETWEEN '20201101' AND '20210131'
    AND user_pseudo_id IS NOT NULL
  GROUP BY 1,2
)
SELECT
  week_start,
  COUNT(*) AS active_users,
  AVG(event_count) AS avg_events_per_active_user,
  AVG(distinct_event_types) AS avg_distinct_event_types_per_active_user,
  COUNTIF(item_views>0) AS users_viewing_items,
  COUNTIF(cart_adds>0) AS users_adding_to_cart,
  SAFE_DIVIDE(COUNTIF(cart_adds>0),COUNTIF(item_views>0)) AS viewer_to_cart_user_rate
FROM user_week
GROUP BY week_start
ORDER BY week_start;
