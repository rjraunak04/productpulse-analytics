-- Inactivity state at the fixed observation endpoint.
WITH u AS (
  SELECT user_pseudo_id,
    MAX(DATE_TRUNC(PARSE_DATE('%Y%m%d',event_date),WEEK(MONDAY))) last_active_week
  FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
  WHERE _TABLE_SUFFIX BETWEEN '20201101' AND '20210131' AND user_pseudo_id IS NOT NULL
  GROUP BY 1
), scored AS (
  SELECT *,
    DATE_DIFF(DATE_TRUNC(DATE '2021-01-31',WEEK(MONDAY)),last_active_week,WEEK) inactive_weeks
  FROM u
)
SELECT *,
  CASE
    WHEN inactive_weeks=0 THEN 'active_this_week'
    WHEN inactive_weeks=1 THEN 'one_week_inactive'
    ELSE 'multiweek_inactive'
  END inactivity_state
FROM scored;
