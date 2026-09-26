-- Observed-window RFM-style segmentation for purchasing pseudonymous users.
-- Scores are relative to this sample, not universal customer tiers.
WITH purchases AS (
  SELECT user_pseudo_id,
    MAX(PARSE_DATE('%Y%m%d',event_date)) last_purchase_date,
    COUNT(*) purchase_events,
    SUM(COALESCE(ecommerce.purchase_revenue_in_usd,0)) revenue
  FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
  WHERE _TABLE_SUFFIX BETWEEN '20201101' AND '20210131'
    AND user_pseudo_id IS NOT NULL AND event_name='purchase'
  GROUP BY 1
), scored AS (
  SELECT *,
    DATE_DIFF(DATE '2021-01-31',last_purchase_date,DAY) recency_days,
    NTILE(5) OVER(ORDER BY DATE_DIFF(DATE '2021-01-31',last_purchase_date,DAY) DESC) recency_score,
    NTILE(5) OVER(ORDER BY purchase_events) frequency_score,
    NTILE(5) OVER(ORDER BY revenue) monetary_score
  FROM purchases
)
SELECT *,
  CASE
    WHEN recency_score>=4 AND frequency_score>=4 AND monetary_score>=4 THEN 'high_value_recent'
    WHEN recency_score>=4 AND frequency_score<=2 THEN 'recent_low_frequency'
    WHEN recency_score<=2 AND frequency_score>=4 THEN 'historically_frequent_inactive'
    ELSE 'core'
  END observed_segment
FROM scored;
