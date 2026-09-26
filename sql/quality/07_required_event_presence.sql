-- Events required by later journey analytics.
WITH required AS (
  SELECT event_name FROM UNNEST([
    'session_start','view_item','add_to_cart','begin_checkout','purchase'
  ]) AS event_name
),
observed AS (
  SELECT event_name, COUNT(*) AS event_rows
  FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
  WHERE _TABLE_SUFFIX BETWEEN '20201101' AND '20210131'
  GROUP BY event_name
)
SELECT
  r.event_name,
  COALESCE(o.event_rows,0) AS event_rows,
  o.event_rows IS NOT NULL AS present
FROM required r LEFT JOIN observed o USING(event_name)
ORDER BY r.event_name;
