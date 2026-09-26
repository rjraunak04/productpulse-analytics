-- event_date is collection-calendar metadata while event_timestamp is UTC timestamp.
-- This query measures, rather than assumes, agreement after UTC conversion.
SELECT
  COUNT(*) AS event_rows,
  COUNTIF(PARSE_DATE('%Y%m%d',event_date) != DATE(TIMESTAMP_MICROS(event_timestamp)))
    AS event_date_utc_date_mismatches,
  MIN(TIMESTAMP_MICROS(event_timestamp)) AS min_event_ts,
  MAX(TIMESTAMP_MICROS(event_timestamp)) AS max_event_ts
FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
WHERE _TABLE_SUFFIX BETWEEN '20201101' AND '20210131';
