-- Cohort = first observed activity week inside the contracted sample.
WITH user_week AS (
  SELECT DISTINCT
    user_pseudo_id,
    DATE_TRUNC(PARSE_DATE('%Y%m%d',event_date),WEEK(MONDAY)) AS activity_week
  FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
  WHERE _TABLE_SUFFIX BETWEEN '20201101' AND '20210131'
    AND user_pseudo_id IS NOT NULL
)
SELECT
  user_pseudo_id,
  MIN(activity_week) AS cohort_week
FROM user_week
GROUP BY user_pseudo_id;
