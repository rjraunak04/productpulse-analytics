-- Item-level integrity after explicit UNNEST.
SELECT
  COUNT(*) AS event_item_rows,
  COUNTIF(item.item_id IS NULL AND item.item_name IS NULL) AS unidentified_items,
  COUNTIF(item.quantity < 0) AS negative_quantity_rows,
  COUNTIF(item.price_in_usd < 0) AS negative_price_rows,
  COUNTIF(item.item_revenue_in_usd < 0) AS negative_item_revenue_rows
FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`,
UNNEST(items) AS item
WHERE _TABLE_SUFFIX BETWEEN '20201101' AND '20210131';
