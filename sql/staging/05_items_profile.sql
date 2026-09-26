-- Item-level profile. UNNEST(items) intentionally changes the grain to one row per event-item.

SELECT
  COUNT(*) AS event_item_rows,
  COUNT(DISTINCT item.item_id) AS distinct_item_ids,
  COUNTIF(item.item_id IS NULL AND item.item_name IS NULL) AS unidentified_item_rows,
  COUNTIF(item.price_in_usd IS NOT NULL) AS rows_with_usd_price
FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`,
UNNEST(items) AS item
WHERE _TABLE_SUFFIX BETWEEN '20201101' AND '20210131';
