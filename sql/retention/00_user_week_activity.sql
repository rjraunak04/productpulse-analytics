-- Grain: pseudonymous user + Monday-based activity week.
SELECT
  user_pseudo_id,
  DATE_TRUNC(PARSE_DATE('%Y%m%d',event_date),WEEK(MONDAY)) AS activity_week,
  COUNT(*) AS event_count,
  COUNTIF(event_name='purchase') AS purchase_events
FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
WHERE _TABLE_SUFFIX BETWEEN '20201101' AND '20210131'
  AND user_pseudo_id IS NOT NULL
GROUP BY 1,2;
