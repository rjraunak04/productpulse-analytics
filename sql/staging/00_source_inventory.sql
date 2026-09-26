-- ProductPulse | GA4 source inventory
-- Official public source:
-- bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*
-- Expected public sample window: 2020-11-01 through 2021-01-31.
-- _TABLE_SUFFIX filters keep wildcard queries bounded and auditable.

SELECT
  MIN(PARSE_DATE('%Y%m%d', event_date)) AS min_event_date,
  MAX(PARSE_DATE('%Y%m%d', event_date)) AS max_event_date,
  COUNT(DISTINCT event_date) AS observed_days,
  COUNT(*) AS event_rows,
  COUNT(DISTINCT user_pseudo_id) AS pseudo_users,
  COUNTIF(user_pseudo_id IS NULL) AS events_without_pseudo_user
FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
WHERE _TABLE_SUFFIX BETWEEN '20201101' AND '20210131';
