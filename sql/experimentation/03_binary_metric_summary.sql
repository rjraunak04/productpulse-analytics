-- Aggregate primary and guardrail binary outcomes by variant.
WITH x AS (
  WITH a AS (
    SELECT user_pseudo_id,CASE
      WHEN MOD(ABS(FARM_FINGERPRINT(CONCAT('productpulse-checkout-v1|',user_pseudo_id))),10000)<5000
        THEN 'control' ELSE 'treatment' END variant
    FROM (
      SELECT DISTINCT user_pseudo_id
      FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
      WHERE _TABLE_SUFFIX BETWEEN '20201101' AND '20210131' AND user_pseudo_id IS NOT NULL
    )
  ), o AS (
    SELECT user_pseudo_id,
      COUNTIF(event_name='purchase')>0 purchased,
      COUNTIF(event_name='begin_checkout')>0 began_checkout
    FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
    WHERE _TABLE_SUFFIX BETWEEN '20201101' AND '20210131' AND user_pseudo_id IS NOT NULL GROUP BY 1
  )
  SELECT a.*,o.* EXCEPT(user_pseudo_id) FROM a JOIN o USING(user_pseudo_id)
)
SELECT variant,COUNT(*) users,
  COUNTIF(purchased) purchase_users,
  SAFE_DIVIDE(COUNTIF(purchased),COUNT(*)) purchase_conversion,
  COUNTIF(began_checkout) checkout_users,
  SAFE_DIVIDE(COUNTIF(began_checkout),COUNT(*)) begin_checkout_rate
FROM x GROUP BY variant ORDER BY variant;
