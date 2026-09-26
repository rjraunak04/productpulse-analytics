-- A transaction appearing on multiple purchase rows is flagged for investigation.
SELECT
  ecommerce.transaction_id AS transaction_id,
  COUNT(*) AS purchase_rows,
  SUM(COALESCE(ecommerce.purchase_revenue_in_usd,0)) AS summed_revenue_usd
FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
WHERE _TABLE_SUFFIX BETWEEN '20201101' AND '20210131'
  AND event_name='purchase'
  AND ecommerce.transaction_id IS NOT NULL
  AND ecommerce.transaction_id!=''
GROUP BY transaction_id
HAVING COUNT(*) > 1
ORDER BY purchase_rows DESC, transaction_id;
