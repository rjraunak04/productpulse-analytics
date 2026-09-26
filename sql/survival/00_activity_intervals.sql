-- Intervals from each observed active week to the next observed active week.
WITH uw AS (
  SELECT DISTINCT user_pseudo_id,
    DATE_TRUNC(PARSE_DATE('%Y%m%d',event_date),WEEK(MONDAY)) activity_week
  FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
  WHERE _TABLE_SUFFIX BETWEEN '20201101' AND '20210131' AND user_pseudo_id IS NOT NULL
), x AS (
  SELECT *,
    LEAD(activity_week) OVER(PARTITION BY user_pseudo_id ORDER BY activity_week) next_active_week
  FROM uw
)
SELECT user_pseudo_id,activity_week,next_active_week,
  DATE_DIFF(COALESCE(next_active_week,DATE_TRUNC(DATE '2021-01-31',WEEK(MONDAY))),
            activity_week,WEEK) duration_weeks,
  next_active_week IS NOT NULL event_observed
FROM x;
