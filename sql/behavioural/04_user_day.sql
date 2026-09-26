-- User-day bridge for future activity/retention metrics.
-- Grain: user_pseudo_id + event_date.
SELECT
  user_pseudo_id,
  PARSE_DATE('%Y%m%d',event_date) AS activity_date,
  COUNT(*) AS event_count,
  COUNT(DISTINCT event_name) AS distinct_event_types,
  COUNTIF(event_name='view_item') AS item_view_events,
  COUNTIF(event_name='add_to_cart') AS add_to_cart_events,
  COUNTIF(event_name='begin_checkout') AS checkout_events,
  COUNTIF(event_name='purchase') AS purchase_events,
  SUM(IF(event_name='purchase',COALESCE(ecommerce.purchase_revenue_in_usd,0),0))
    AS purchase_revenue_usd
FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
WHERE _TABLE_SUFFIX BETWEEN '20201101' AND '20210131'
  AND user_pseudo_id IS NOT NULL
GROUP BY user_pseudo_id,activity_date;
