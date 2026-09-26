-- Distribution of observed return times; censored intervals are reported separately.
WITH intervals AS (
  WITH uw AS (
    SELECT DISTINCT user_pseudo_id,
      DATE_TRUNC(PARSE_DATE('%Y%m%d',event_date),WEEK(MONDAY)) activity_week
    FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
    WHERE _TABLE_SUFFIX BETWEEN '20201101' AND '20210131' AND user_pseudo_id IS NOT NULL
  )
  SELECT user_pseudo_id,activity_week,
    LEAD(activity_week) OVER(PARTITION BY user_pseudo_id ORDER BY activity_week) next_week
  FROM uw
)
SELECT
  DATE_DIFF(COALESCE(next_week,DATE_TRUNC(DATE '2021-01-31',WEEK(MONDAY))),activity_week,WEEK)
    duration_weeks,
  next_week IS NOT NULL event_observed,
  COUNT(*) intervals
FROM intervals
GROUP BY 1,2 ORDER BY 1,2;
