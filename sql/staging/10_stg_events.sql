-- Canonical event-grain staging query.
-- One source event remains one output row; repeated arrays are not unnested here.

SELECT
  PARSE_DATE('%Y%m%d', event_date) AS event_date,
  TIMESTAMP_MICROS(event_timestamp) AS event_ts,
  event_name,
  user_pseudo_id,
  user_id,
  TIMESTAMP_MICROS(user_first_touch_timestamp) AS user_first_touch_ts,
  platform,
  device.category AS device_category,
  device.operating_system,
  device.browser,
  geo.continent,
  geo.country,
  geo.region,
  traffic_source.name AS first_user_campaign,
  traffic_source.medium AS first_user_medium,
  traffic_source.source AS first_user_source,
  ecommerce.transaction_id,
  ecommerce.purchase_revenue_in_usd,
  ecommerce.total_item_quantity,

  -- Common GA4 web parameters are extracted without changing event grain.
  (SELECT value.int_value
   FROM UNNEST(event_params)
   WHERE key = 'ga_session_id'
   LIMIT 1) AS ga_session_id,

  (SELECT value.int_value
   FROM UNNEST(event_params)
   WHERE key = 'ga_session_number'
   LIMIT 1) AS ga_session_number,

  (SELECT value.string_value
   FROM UNNEST(event_params)
   WHERE key = 'page_location'
   LIMIT 1) AS page_location,

  (SELECT value.string_value
   FROM UNNEST(event_params)
   WHERE key = 'page_title'
   LIMIT 1) AS page_title
FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
WHERE _TABLE_SUFFIX BETWEEN '20201101' AND '20210131';
