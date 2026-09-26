-- Distribution diagnostics to prevent averages from hiding skew.
WITH u AS (
  SELECT user_pseudo_id,
    SUM(IF(event_name='purchase',COALESCE(ecommerce.purchase_revenue_in_usd,0),0)) revenue
  FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
  WHERE _TABLE_SUFFIX BETWEEN '20201101' AND '20210131' AND user_pseudo_id IS NOT NULL
  GROUP BY 1
)
SELECT
  COUNT(*) observed_users,
  COUNTIF(revenue>0) users_with_revenue,
  AVG(revenue) mean_observed_revenue,
  APPROX_QUANTILES(revenue,100)[OFFSET(50)] median_observed_revenue,
  APPROX_QUANTILES(revenue,100)[OFFSET(75)] p75_observed_revenue,
  APPROX_QUANTILES(revenue,100)[OFFSET(90)] p90_observed_revenue,
  APPROX_QUANTILES(revenue,100)[OFFSET(95)] p95_observed_revenue,
  APPROX_QUANTILES(revenue,100)[OFFSET(99)] p99_observed_revenue
FROM u;
