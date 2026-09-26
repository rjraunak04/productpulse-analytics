-- Survival input invariants.
WITH uw AS (
  SELECT DISTINCT user_pseudo_id,
    DATE_TRUNC(PARSE_DATE('%Y%m%d',event_date),WEEK(MONDAY)) activity_week
  FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
  WHERE _TABLE_SUFFIX BETWEEN '20201101' AND '20210131' AND user_pseudo_id IS NOT NULL
), x AS (
  SELECT *,LEAD(activity_week) OVER(PARTITION BY user_pseudo_id ORDER BY activity_week) next_week
  FROM uw
), i AS (
  SELECT *,
    DATE_DIFF(COALESCE(next_week,DATE_TRUNC(DATE '2021-01-31',WEEK(MONDAY))),activity_week,WEEK) duration
  FROM x
)
SELECT
  COUNT(*) intervals,
  COUNTIF(duration<0) negative_durations,
  COUNTIF(next_week IS NOT NULL AND next_week<=activity_week) nonforward_return_events,
  COUNTIF(next_week IS NULL AND activity_week>DATE_TRUNC(DATE '2021-01-31',WEEK(MONDAY)))
    invalid_censor_origins
FROM i;
