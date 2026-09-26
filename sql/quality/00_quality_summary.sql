-- ProductPulse Step 3 | event-level quality summary
WITH events AS (
  SELECT
    PARSE_DATE('%Y%m%d', event_date) AS event_date,
    TIMESTAMP_MICROS(event_timestamp) AS event_ts,
    event_name,
    user_pseudo_id,
    ecommerce.purchase_revenue_in_usd,
    (SELECT value.int_value FROM UNNEST(event_params)
     WHERE key='ga_session_id' LIMIT 1) AS ga_session_id
  FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
  WHERE _TABLE_SUFFIX BETWEEN '20201101' AND '20210131'
)
SELECT
  COUNT(*) AS event_rows,
  COUNTIF(event_date IS NULL) AS null_event_date,
  COUNTIF(event_ts IS NULL) AS null_event_ts,
  COUNTIF(event_name IS NULL OR TRIM(event_name)='') AS missing_event_name,
  COUNTIF(user_pseudo_id IS NULL OR TRIM(user_pseudo_id)='') AS missing_pseudo_user,
  COUNTIF(ga_session_id IS NULL) AS missing_session_id,
  COUNTIF(purchase_revenue_in_usd < 0) AS negative_purchase_revenue,
  COUNTIF(event_date < DATE '2020-11-01' OR event_date > DATE '2021-01-31')
    AS events_outside_contract
FROM events;
