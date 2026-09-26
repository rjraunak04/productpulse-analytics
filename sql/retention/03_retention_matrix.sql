-- Recruiter-readable W0-W8 cohort matrix.
WITH long_retention AS (
  WITH uw AS (
    SELECT DISTINCT user_pseudo_id,
      DATE_TRUNC(PARSE_DATE('%Y%m%d',event_date),WEEK(MONDAY)) activity_week
    FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
    WHERE _TABLE_SUFFIX BETWEEN '20201101' AND '20210131' AND user_pseudo_id IS NOT NULL
  ), c AS (
    SELECT user_pseudo_id,MIN(activity_week) cohort_week FROM uw GROUP BY 1
  ), x AS (
    SELECT c.user_pseudo_id,c.cohort_week,DATE_DIFF(uw.activity_week,c.cohort_week,WEEK) n
    FROM c JOIN uw USING(user_pseudo_id)
  ), s AS (SELECT cohort_week,COUNT(*) size FROM c GROUP BY 1)
  SELECT x.cohort_week,x.n,SAFE_DIVIDE(COUNT(DISTINCT x.user_pseudo_id),s.size) rate
  FROM x JOIN s USING(cohort_week) GROUP BY 1,2,s.size
)
SELECT cohort_week,
  MAX(IF(n=0,rate,NULL)) w0,
  MAX(IF(n=1,rate,NULL)) w1,
  MAX(IF(n=2,rate,NULL)) w2,
  MAX(IF(n=3,rate,NULL)) w3,
  MAX(IF(n=4,rate,NULL)) w4,
  MAX(IF(n=5,rate,NULL)) w5,
  MAX(IF(n=6,rate,NULL)) w6,
  MAX(IF(n=7,rate,NULL)) w7,
  MAX(IF(n=8,rate,NULL)) w8
FROM long_retention GROUP BY cohort_week ORDER BY cohort_week;
