-- Observed-window user value. This is NOT lifetime value.
SELECT
  user_pseudo_id,
  MIN(PARSE_DATE('%Y%m%d',event_date)) AS first_observed_date,
  MAX(PARSE_DATE('%Y%m%d',event_date)) AS last_observed_date,
  COUNTIF(event_name='purchase') AS purchase_events,
  SUM(IF(event_name='purchase',COALESCE(ecommerce.purchase_revenue_in_usd,0),0))
    AS observed_purchase_revenue_usd,
  COUNT(DISTINCT IF(event_name='purchase',ecommerce.transaction_id,NULL))
    AS distinct_transaction_ids
FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
WHERE _TABLE_SUFFIX BETWEEN '20201101' AND '20210131'
  AND user_pseudo_id IS NOT NULL
GROUP BY 1;
