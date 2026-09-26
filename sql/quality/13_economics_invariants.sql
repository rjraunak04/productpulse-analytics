-- Monetization invariants.
WITH u AS (
  SELECT user_pseudo_id,
    COUNTIF(event_name='purchase') purchases,
    SUM(IF(event_name='purchase',COALESCE(ecommerce.purchase_revenue_in_usd,0),0)) revenue
  FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
  WHERE _TABLE_SUFFIX BETWEEN '20201101' AND '20210131' AND user_pseudo_id IS NOT NULL
  GROUP BY 1
)
SELECT
  COUNT(*) users,
  COUNTIF(purchases<0) negative_purchase_count_users,
  COUNTIF(revenue<0) negative_observed_revenue_users,
  COUNTIF(purchases=0 AND revenue!=0) revenue_without_purchase_users
FROM u;
