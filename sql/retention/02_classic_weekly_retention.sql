-- Classic weekly retention matrix in long form.
WITH user_week AS (
  SELECT DISTINCT user_pseudo_id,
    DATE_TRUNC(PARSE_DATE('%Y%m%d',event_date),WEEK(MONDAY)) activity_week
  FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
  WHERE _TABLE_SUFFIX BETWEEN '20201101' AND '20210131' AND user_pseudo_id IS NOT NULL
),
cohorts AS (
  SELECT user_pseudo_id,MIN(activity_week) cohort_week FROM user_week GROUP BY 1
),
observed AS (
  SELECT c.user_pseudo_id,c.cohort_week,u.activity_week,
    DATE_DIFF(u.activity_week,c.cohort_week,WEEK) week_number
  FROM cohorts c JOIN user_week u USING(user_pseudo_id)
),
sizes AS (
  SELECT cohort_week,COUNT(*) cohort_size FROM cohorts GROUP BY 1
)
SELECT
  o.cohort_week,o.week_number,s.cohort_size,
  COUNT(DISTINCT o.user_pseudo_id) retained_users,
  SAFE_DIVIDE(COUNT(DISTINCT o.user_pseudo_id),s.cohort_size) retention_rate,
  DATE_ADD(o.cohort_week,INTERVAL o.week_number WEEK) <= DATE '2021-01-31'
    AS observable_within_window
FROM observed o JOIN sizes s USING(cohort_week)
GROUP BY 1,2,3
ORDER BY cohort_week,week_number;
