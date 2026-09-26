-- Metric-layer invariants. Non-zero violations require investigation.
WITH user_week AS (
  SELECT
    user_pseudo_id,
    DATE_TRUNC(PARSE_DATE('%Y%m%d',event_date),WEEK(MONDAY)) AS week_start,
    COUNTIF(event_name='purchase') AS purchases
  FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
  WHERE _TABLE_SUFFIX BETWEEN '20201101' AND '20210131'
    AND user_pseudo_id IS NOT NULL
  GROUP BY 1,2
),
weekly AS (
  SELECT
    week_start,
    COUNT(*) active_users,
    COUNTIF(purchases>0) activated_users
  FROM user_week GROUP BY 1
)
SELECT
  COUNT(*) AS weeks,
  COUNTIF(activated_users>active_users) AS activation_exceeds_active_violations,
  COUNTIF(active_users<=0) AS nonpositive_active_user_weeks,
  COUNTIF(SAFE_DIVIDE(activated_users,active_users)<0
          OR SAFE_DIVIDE(activated_users,active_users)>1) AS invalid_activation_rate_weeks
FROM weekly;
