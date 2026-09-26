-- Weekly product KPI layer.
WITH user_week AS (
  SELECT
    user_pseudo_id,
    DATE_TRUNC(PARSE_DATE('%Y%m%d',event_date),WEEK(MONDAY)) AS week_start,
    COUNTIF(event_name='purchase') AS purchase_events,
    SUM(IF(event_name='purchase',COALESCE(ecommerce.purchase_revenue_in_usd,0),0))
      AS revenue_usd
  FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
  WHERE _TABLE_SUFFIX BETWEEN '20201101' AND '20210131'
    AND user_pseudo_id IS NOT NULL
  GROUP BY 1,2
),
weekly AS (
  SELECT
    week_start,
    COUNT(*) AS weekly_active_users,
    COUNTIF(purchase_events>0) AS weekly_activated_users,
    SUM(purchase_events) AS purchase_events,
    SUM(revenue_usd) AS purchase_revenue_usd
  FROM user_week
  GROUP BY week_start
)
SELECT
  week_start,
  weekly_active_users,
  weekly_activated_users,
  SAFE_DIVIDE(weekly_activated_users,weekly_active_users) AS weekly_activation_rate,
  purchase_events,
  purchase_revenue_usd,
  SAFE_DIVIDE(purchase_revenue_usd,weekly_active_users) AS revenue_per_active_user,
  SAFE_DIVIDE(purchase_revenue_usd,purchase_events) AS average_purchase_value,
  week_start < DATE '2020-11-01'
    OR DATE_ADD(week_start,INTERVAL 6 DAY) > DATE '2021-01-31' AS partial_observation_week
FROM weekly
ORDER BY week_start;
