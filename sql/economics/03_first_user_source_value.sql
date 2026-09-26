-- Revenue context by FIRST-USER acquisition source/medium.
-- Do not interpret as session-level attribution or incremental marketing return.
WITH user_context AS (
  SELECT
    user_pseudo_id,
    ARRAY_AGG(STRUCT(
      TIMESTAMP_MICROS(event_timestamp) AS ts,
      traffic_source.source AS source,
      traffic_source.medium AS medium
    ) ORDER BY event_timestamp LIMIT 1)[OFFSET(0)] first_record,
    COUNTIF(event_name='purchase') purchases,
    SUM(IF(event_name='purchase',COALESCE(ecommerce.purchase_revenue_in_usd,0),0)) revenue
  FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
  WHERE _TABLE_SUFFIX BETWEEN '20201101' AND '20210131' AND user_pseudo_id IS NOT NULL
  GROUP BY 1
)
SELECT
  COALESCE(first_record.source,'(not set)') first_user_source,
  COALESCE(first_record.medium,'(not set)') first_user_medium,
  COUNT(*) observed_users,
  COUNTIF(purchases>0) purchasing_users,
  SUM(revenue) observed_purchase_revenue_usd,
  SAFE_DIVIDE(SUM(revenue),COUNT(*)) revenue_per_observed_user,
  SAFE_DIVIDE(COUNTIF(purchases>0),COUNT(*)) observed_purchase_user_rate
FROM user_context
GROUP BY 1,2
ORDER BY observed_purchase_revenue_usd DESC;
