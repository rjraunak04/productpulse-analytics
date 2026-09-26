-- Quantify maximum observable follow-up for every cohort.
WITH c AS (
  SELECT user_pseudo_id,
    MIN(DATE_TRUNC(PARSE_DATE('%Y%m%d',event_date),WEEK(MONDAY))) cohort_week
  FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
  WHERE _TABLE_SUFFIX BETWEEN '20201101' AND '20210131' AND user_pseudo_id IS NOT NULL
  GROUP BY 1
)
SELECT cohort_week,COUNT(*) cohort_size,
  DATE_DIFF(DATE_TRUNC(DATE '2021-01-31',WEEK(MONDAY)),cohort_week,WEEK)
    AS max_observable_week_number
FROM c GROUP BY 1 ORDER BY 1;
