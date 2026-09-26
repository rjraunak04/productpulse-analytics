-- Join deterministic demo assignment to observed behavioural outcomes.
-- Assignment is simulated; outcomes are observed GA4 events in the sample.
WITH assignment AS (
  SELECT user_pseudo_id,
    CASE WHEN MOD(ABS(FARM_FINGERPRINT(CONCAT('productpulse-checkout-v1|',user_pseudo_id))),10000)<5000
      THEN 'control' ELSE 'treatment' END variant
  FROM (
    SELECT DISTINCT user_pseudo_id
    FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
    WHERE _TABLE_SUFFIX BETWEEN '20201101' AND '20210131' AND user_pseudo_id IS NOT NULL
  )
),
outcomes AS (
  SELECT user_pseudo_id,
    COUNTIF(event_name='purchase')>0 AS purchased,
    COUNTIF(event_name='begin_checkout')>0 AS began_checkout
  FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
  WHERE _TABLE_SUFFIX BETWEEN '20201101' AND '20210131' AND user_pseudo_id IS NOT NULL
  GROUP BY 1
)
SELECT a.user_pseudo_id,a.variant,o.purchased,o.began_checkout
FROM assignment a JOIN outcomes o USING(user_pseudo_id);
