# GA4 schema notes

## Event grain

Before expanding repeated records, a row represents an exported event. Core fields used by ProductPulse include:

- `event_date`
- `event_timestamp`
- `event_name`
- `user_pseudo_id`
- `user_id`
- `user_first_touch_timestamp`
- `platform`
- `device`
- `geo`
- `traffic_source`
- `ecommerce`
- `event_params`
- `items`

## Repeated records

### event_params
Key/value parameters associated with an event. Values may occupy string, integer, double or float slots. Parameter availability is implementation-specific, so Step 2 includes a discovery query instead of assuming every parameter exists.

### items
Repeated ecommerce item records. Unnesting creates item grain and must not be joined back to event aggregates without controlling duplication.

## Timestamp convention

`event_timestamp` and `user_first_touch_timestamp` are converted from microseconds with `TIMESTAMP_MICROS`.

## Session convention

The staging query attempts to extract `ga_session_id` and `ga_session_number` from event parameters. Their actual coverage must be measured before they become contractual session keys.

## Revenue convention

The staging layer retains `ecommerce.purchase_revenue_in_usd`. Revenue metrics will be defined only after Step 3 quality checks establish event and transaction behaviour.
