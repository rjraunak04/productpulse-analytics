# Behavioural analytics layer

Step 4 creates reusable analytical grains between raw GA4 events and later product metrics.

## Grains

### Event
One exported GA4 event. Repeated arrays remain unexpanded.

### Session
One `user_pseudo_id + ga_session_id` pair. This composite is deliberate: a GA4 session ID is not treated as globally unique across users.

Events missing either key component are excluded from the session model, **not silently reassigned**. Their coverage is reported by the reconciliation query.

### User
One `user_pseudo_id` over the fixed public-sample observation window. User metrics are therefore labelled **observed** rather than lifetime metrics.

### User-day
One user and calendar activity date. This bridge supports later active-user and retention calculations without repeatedly scanning event detail.

### Session-event sequence
One ordered event position inside a session. It preserves previous/next event context for later journey diagnostics.

## Session duration

Duration is `max(event_ts) - min(event_ts)`. It is named `observed_session_duration_seconds` because event logs do not prove how long a user remained attentive after the final event. A one-event session can therefore have observed duration zero.

## Journey flags

The session model records whether the session contains:
`view_item`, `add_to_cart`, `begin_checkout`, and `purchase`.

These are behavioural building blocks, not yet the Step 6 ordered funnel. A session containing both events does not automatically prove that they occurred in funnel order; the sequence model will support that distinction.

## Attribution

First-user source/medium are carried as context only. They are not relabelled as session acquisition.

## No synthetic fallback sessions

ProductPulse does not manufacture 30-minute inactivity sessions for events missing `ga_session_id`. Doing so would mix GA4-defined sessions with analyst-defined sessions. If fallback sessionization is ever needed, it must be a separately named model.
