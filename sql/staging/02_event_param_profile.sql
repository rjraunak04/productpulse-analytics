-- Discover event parameters before relying on them in metric definitions.
-- Repeated event_params must be unnested deliberately.

SELECT
  ep.key AS parameter_key,
  COUNT(*) AS occurrences,
  COUNTIF(ep.value.string_value IS NOT NULL) AS string_values,
  COUNTIF(ep.value.int_value IS NOT NULL) AS int_values,
  COUNTIF(ep.value.double_value IS NOT NULL) AS double_values,
  COUNT(DISTINCT event_name) AS event_names_using_parameter
FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`,
UNNEST(event_params) AS ep
WHERE _TABLE_SUFFIX BETWEEN '20201101' AND '20210131'
GROUP BY parameter_key
ORDER BY occurrences DESC, parameter_key;
