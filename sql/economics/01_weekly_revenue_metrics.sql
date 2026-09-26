-- Weekly monetization context.
WITH user_week AS (
  SELECT user_pseudo_id,
    DATE_TRUNC(PARSE_DATE('%Y%m%d',event_date),WEEK(MONDAY)) week_start,
    COUNTIF(event_name='purchase') purchases,
    SUM(IF(event_name='purchase',COALESCE(ecommerce.purchase_revenue_in_usd,0),0)) revenue
  FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
  WHERE _TABLE_SUFFIX BETWEEN '20201101' AND '20210131' AND user_pseudo_id IS NOT NULL
  GROUP BY 1,2
)
SELECT week_start,
  COUNT(*) active_users,
  COUNTIF(purchases>0) purchasing_users,
  SUM(purchases) purchase_events,
  SUM(revenue) purchase_revenue_usd,
  SAFE_DIVIDE(SUM(revenue),COUNT(*)) revenue_per_active_user,
  SAFE_DIVIDE(SUM(revenue),COUNTIF(purchases>0)) revenue_per_purchasing_user,
  SAFE_DIVIDE(SUM(purchases),COUNTIF(purchases>0)) purchase_events_per_purchasing_user
FROM user_week GROUP BY 1 ORDER BY 1;
