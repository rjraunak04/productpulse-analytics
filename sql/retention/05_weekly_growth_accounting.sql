-- Observed active-user growth accounting.
WITH uw AS (
  SELECT DISTINCT user_pseudo_id,
    DATE_TRUNC(PARSE_DATE('%Y%m%d',event_date),WEEK(MONDAY)) activity_week
  FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
  WHERE _TABLE_SUFFIX BETWEEN '20201101' AND '20210131' AND user_pseudo_id IS NOT NULL
),
weeks AS (SELECT DISTINCT activity_week FROM uw),
states AS (
  SELECT w.activity_week,u.user_pseudo_id,
    EXISTS(SELECT 1 FROM uw x WHERE x.user_pseudo_id=u.user_pseudo_id AND x.activity_week=w.activity_week) active_now,
    EXISTS(SELECT 1 FROM uw x WHERE x.user_pseudo_id=u.user_pseudo_id AND x.activity_week=DATE_SUB(w.activity_week,INTERVAL 1 WEEK)) active_prior,
    EXISTS(SELECT 1 FROM uw x WHERE x.user_pseudo_id=u.user_pseudo_id AND x.activity_week<w.activity_week) active_before
  FROM weeks w CROSS JOIN (SELECT DISTINCT user_pseudo_id FROM uw) u
)
SELECT activity_week,
  COUNTIF(active_now) active_users,
  COUNTIF(active_now AND NOT active_before) new_observed_users,
  COUNTIF(active_now AND active_prior) retained_users,
  COUNTIF(active_now AND NOT active_prior AND active_before) resurrected_users,
  COUNTIF(NOT active_now AND active_prior) newly_inactive_users
FROM states
GROUP BY 1 ORDER BY 1;
