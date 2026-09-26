-- Observed repeat-purchase behaviour at pseudonymous-user level.
WITH u AS (
  SELECT user_pseudo_id,COUNTIF(event_name='purchase') purchase_events
  FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
  WHERE _TABLE_SUFFIX BETWEEN '20201101' AND '20210131' AND user_pseudo_id IS NOT NULL
  GROUP BY 1
)
SELECT
  COUNTIF(purchase_events>0) purchasing_users,
  COUNTIF(purchase_events>=2) repeat_purchasing_users,
  SAFE_DIVIDE(COUNTIF(purchase_events>=2),COUNTIF(purchase_events>0))
    AS observed_repeat_purchase_rate
FROM u;
