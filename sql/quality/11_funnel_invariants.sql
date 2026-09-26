-- Run against a materialized/view version of ordered_session_funnel.
SELECT
  COUNT(*) AS funnel_entry_sessions,
  COUNTIF(view_item_ts < session_start_ts) AS invalid_stage_2_order,
  COUNTIF(add_to_cart_ts < view_item_ts) AS invalid_stage_3_order,
  COUNTIF(begin_checkout_ts < add_to_cart_ts) AS invalid_stage_4_order,
  COUNTIF(purchase_ts < begin_checkout_ts) AS invalid_stage_5_order,
  COUNT(*)-COUNT(DISTINCT CONCAT(user_pseudo_id,'|',CAST(ga_session_id AS STRING))) AS duplicate_session_rows
FROM `ordered_session_funnel`;
