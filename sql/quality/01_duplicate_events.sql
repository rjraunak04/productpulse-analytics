-- Candidate exact-event duplicate diagnostic.
-- GA4 does not expose a universal primary key, so this is a diagnostic rather than deletion logic.
WITH base AS (
  SELECT
    event_date,
    event_timestamp,
    event_name,
    user_pseudo_id,
    event_bundle_sequence_id,
    batch_event_index
  FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
  WHERE _TABLE_SUFFIX BETWEEN '20201101' AND '20210131'
),
groups AS (
  SELECT
    event_date,event_timestamp,event_name,user_pseudo_id,
    event_bundle_sequence_id,batch_event_index,
    COUNT(*) AS row_count
  FROM base
  GROUP BY 1,2,3,4,5,6
)
SELECT
  COUNTIF(row_count > 1) AS duplicate_groups,
  COALESCE(SUM(IF(row_count > 1, row_count - 1, 0)),0) AS excess_rows
FROM groups;
