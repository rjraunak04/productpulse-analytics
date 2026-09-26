-- DEMONSTRATION ONLY: deterministic simulated experiment assignment.
-- This is NOT an observed Google Merchandise Store experiment.
WITH users AS (
  SELECT DISTINCT user_pseudo_id
  FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
  WHERE _TABLE_SUFFIX BETWEEN '20201101' AND '20210131'
    AND user_pseudo_id IS NOT NULL
)
SELECT
  user_pseudo_id,
  'checkout_experience_demo_v1' AS experiment_id,
  CASE
    WHEN MOD(ABS(FARM_FINGERPRINT(CONCAT('productpulse-checkout-v1|',user_pseudo_id))),10000)<5000
      THEN 'control'
    ELSE 'treatment'
  END AS variant,
  'simulated_deterministic_hash' AS assignment_source
FROM users;
