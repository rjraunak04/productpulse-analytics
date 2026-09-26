-- Canonical item grain: one row per event-item.
-- event_timestamp + user_pseudo_id + item offset are retained for traceability.

SELECT
  PARSE_DATE('%Y%m%d', event_date) AS event_date,
  TIMESTAMP_MICROS(event_timestamp) AS event_ts,
  event_name,
  user_pseudo_id,
  ecommerce.transaction_id,
  item_offset,
  item.item_id,
  item.item_name,
  item.item_brand,
  item.item_variant,
  item.item_category,
  item.price_in_usd,
  item.quantity,
  item.item_revenue_in_usd
FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`,
UNNEST(items) AS item WITH OFFSET AS item_offset
WHERE _TABLE_SUFFIX BETWEEN '20201101' AND '20210131';
