-- Detect missing calendar days and suspicious daily-volume changes.
WITH calendar AS (
  SELECT day
  FROM UNNEST(GENERATE_DATE_ARRAY(DATE '2020-11-01', DATE '2021-01-31')) AS day
),
daily AS (
  SELECT
    PARSE_DATE('%Y%m%d', event_date) AS day,
    COUNT(*) AS event_rows,
    COUNT(DISTINCT user_pseudo_id) AS pseudo_users
  FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
  WHERE _TABLE_SUFFIX BETWEEN '20201101' AND '20210131'
  GROUP BY 1
),
joined AS (
  SELECT
    c.day,
    COALESCE(d.event_rows,0) AS event_rows,
    COALESCE(d.pseudo_users,0) AS pseudo_users
  FROM calendar c LEFT JOIN daily d USING(day)
)
SELECT
  *,
  LAG(event_rows) OVER(ORDER BY day) AS prior_day_events,
  SAFE_DIVIDE(event_rows-LAG(event_rows) OVER(ORDER BY day),
              LAG(event_rows) OVER(ORDER BY day)) AS day_over_day_change
FROM joined
ORDER BY day;
