-- Ecommerce event coverage without exploding the repeated items array.

SELECT
  event_name,
  COUNT(*) AS event_rows,
  COUNTIF(ecommerce.transaction_id IS NOT NULL) AS rows_with_transaction_id,
  COUNT(DISTINCT NULLIF(ecommerce.transaction_id, '')) AS distinct_transactions,
  SUM(COALESCE(ecommerce.purchase_revenue_in_usd, 0)) AS purchase_revenue_usd,
  SUM(COALESCE(ecommerce.total_item_quantity, 0)) AS item_quantity
FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
WHERE _TABLE_SUFFIX BETWEEN '20201101' AND '20210131'
GROUP BY event_name
HAVING rows_with_transaction_id > 0
   OR purchase_revenue_usd != 0
   OR item_quantity != 0
ORDER BY event_rows DESC;
