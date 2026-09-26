-- Session parameter coverage by event name.
SELECT
  event_name,
  COUNT(*) AS event_rows,
  COUNTIF((SELECT value.int_value FROM UNNEST(event_params)
           WHERE key='ga_session_id' LIMIT 1) IS NOT NULL) AS rows_with_session_id,
  SAFE_DIVIDE(
    COUNTIF((SELECT value.int_value FROM UNNEST(event_params)
             WHERE key='ga_session_id' LIMIT 1) IS NOT NULL),
    COUNT(*)
  ) AS session_id_coverage
FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
WHERE _TABLE_SUFFIX BETWEEN '20201101' AND '20210131'
GROUP BY event_name
ORDER BY event_rows DESC;
