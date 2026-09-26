-- Classify each observed user-week as new, retained, or resurrected.
WITH uw AS (
  SELECT DISTINCT user_pseudo_id,
    DATE_TRUNC(PARSE_DATE('%Y%m%d',event_date),WEEK(MONDAY)) activity_week
  FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
  WHERE _TABLE_SUFFIX BETWEEN '20201101' AND '20210131' AND user_pseudo_id IS NOT NULL
),
sequenced AS (
  SELECT *,MIN(activity_week) OVER(PARTITION BY user_pseudo_id) first_week,
    LAG(activity_week) OVER(PARTITION BY user_pseudo_id ORDER BY activity_week) prior_active_week
  FROM uw
)
SELECT user_pseudo_id,activity_week,
  CASE
    WHEN activity_week=first_week THEN 'new_observed'
    WHEN DATE_DIFF(activity_week,prior_active_week,WEEK)=1 THEN 'retained'
    WHEN DATE_DIFF(activity_week,prior_active_week,WEEK)>1 THEN 'resurrected'
    ELSE 'unclassified'
  END lifecycle_state,
  prior_active_week
FROM sequenced;
