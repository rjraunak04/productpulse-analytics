-- Retention invariants from the long-form logic.
WITH uw AS (
  SELECT DISTINCT user_pseudo_id,
    DATE_TRUNC(PARSE_DATE('%Y%m%d',event_date),WEEK(MONDAY)) activity_week
  FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
  WHERE _TABLE_SUFFIX BETWEEN '20201101' AND '20210131' AND user_pseudo_id IS NOT NULL
), c AS (
  SELECT user_pseudo_id,MIN(activity_week) cohort_week FROM uw GROUP BY 1
), r AS (
  SELECT c.cohort_week,DATE_DIFF(uw.activity_week,c.cohort_week,WEEK) n,
    COUNT(DISTINCT uw.user_pseudo_id) retained
  FROM c JOIN uw USING(user_pseudo_id) GROUP BY 1,2
), s AS (SELECT cohort_week,COUNT(*) size FROM c GROUP BY 1)
SELECT
  COUNT(*) cohort_week_rows,
  COUNTIF(r.n<0) negative_week_numbers,
  COUNTIF(r.retained>s.size) retained_exceeds_cohort,
  COUNTIF(r.n=0 AND r.retained!=s.size) week_zero_not_full_cohort,
  COUNTIF(SAFE_DIVIDE(r.retained,s.size)<0 OR SAFE_DIVIDE(r.retained,s.size)>1)
    invalid_retention_rates
FROM r JOIN s USING(cohort_week);
