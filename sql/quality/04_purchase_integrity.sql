-- Purchase-specific integrity checks.
SELECT
  COUNT(*) AS purchase_rows,
  COUNTIF(ecommerce.transaction_id IS NULL OR ecommerce.transaction_id='') AS purchases_without_transaction_id,
  COUNTIF(ecommerce.purchase_revenue_in_usd IS NULL) AS purchases_without_usd_revenue,
  COUNTIF(ecommerce.purchase_revenue_in_usd < 0) AS purchases_with_negative_revenue,
  COUNT(DISTINCT NULLIF(ecommerce.transaction_id,'')) AS distinct_transaction_ids
FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
WHERE _TABLE_SUFFIX BETWEEN '20201101' AND '20210131'
  AND event_name='purchase';
