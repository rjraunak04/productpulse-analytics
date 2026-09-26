-- Event vocabulary and coverage.

SELECT
  event_name,
  COUNT(*) AS event_rows,
  COUNT(DISTINCT user_pseudo_id) AS pseudo_users,
  MIN(PARSE_DATE('%Y%m%d', event_date)) AS first_seen_date,
  MAX(PARSE_DATE('%Y%m%d', event_date)) AS last_seen_date
FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
WHERE _TABLE_SUFFIX BETWEEN '20201101' AND '20210131'
GROUP BY event_name
ORDER BY event_rows DESC, event_name;
