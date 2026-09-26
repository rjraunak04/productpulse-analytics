-- Descriptive endpoint inactivity distribution; not permanent churn.
WITH u AS (
  SELECT user_pseudo_id,
    DATE_DIFF(
      DATE_TRUNC(DATE '2021-01-31',WEEK(MONDAY)),
      MAX(DATE_TRUNC(PARSE_DATE('%Y%m%d',event_date),WEEK(MONDAY))),
      WEEK
    ) inactive_weeks
  FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
  WHERE _TABLE_SUFFIX BETWEEN '20201101' AND '20210131' AND user_pseudo_id IS NOT NULL
  GROUP BY 1
)
SELECT
  CASE WHEN inactive_weeks=0 THEN 'active_this_week'
       WHEN inactive_weeks=1 THEN 'one_week_inactive'
       ELSE 'multiweek_inactive' END inactivity_state,
  COUNT(*) users,
  SAFE_DIVIDE(COUNT(*),SUM(COUNT(*)) OVER()) user_share
FROM u GROUP BY 1 ORDER BY users DESC;
