-- Coverage of dimensions that may support segmentation later.

SELECT
  COALESCE(device.category, '(not set)') AS device_category,
  COALESCE(geo.country, '(not set)') AS country,
  COALESCE(traffic_source.source, '(not set)') AS acquisition_source,
  COALESCE(traffic_source.medium, '(not set)') AS acquisition_medium,
  COUNT(*) AS event_rows,
  COUNT(DISTINCT user_pseudo_id) AS pseudo_users
FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
WHERE _TABLE_SUFFIX BETWEEN '20201101' AND '20210131'
GROUP BY 1,2,3,4
ORDER BY event_rows DESC;
