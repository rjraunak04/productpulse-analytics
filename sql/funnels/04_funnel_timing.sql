-- Time between ordered stages for completed transitions.
-- Uses canonical ordered funnel output when materialized as ordered_session_funnel.
-- Standalone users can substitute the CTE from 01_ordered_session_funnel.sql.
SELECT
  APPROX_QUANTILES(TIMESTAMP_DIFF(view_item_ts,session_start_ts,SECOND),100)[OFFSET(50)] AS median_start_to_view_seconds,
  APPROX_QUANTILES(TIMESTAMP_DIFF(add_to_cart_ts,view_item_ts,SECOND),100)[OFFSET(50)] AS median_view_to_cart_seconds,
  APPROX_QUANTILES(TIMESTAMP_DIFF(begin_checkout_ts,add_to_cart_ts,SECOND),100)[OFFSET(50)] AS median_cart_to_checkout_seconds,
  APPROX_QUANTILES(TIMESTAMP_DIFF(purchase_ts,begin_checkout_ts,SECOND),100)[OFFSET(50)] AS median_checkout_to_purchase_seconds
FROM `ordered_session_funnel`;
