-- Sample ratio and variant counts for SRM analysis.
WITH a AS (
  SELECT CASE
    WHEN MOD(ABS(FARM_FINGERPRINT(CONCAT('productpulse-checkout-v1|',user_pseudo_id))),10000)<5000
      THEN 'control' ELSE 'treatment' END variant
  FROM (
    SELECT DISTINCT user_pseudo_id
    FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
    WHERE _TABLE_SUFFIX BETWEEN '20201101' AND '20210131' AND user_pseudo_id IS NOT NULL
  )
)
SELECT variant,COUNT(*) assigned_users,
  SAFE_DIVIDE(COUNT(*),SUM(COUNT(*)) OVER()) observed_share,
  0.5 expected_share
FROM a GROUP BY variant ORDER BY variant;
