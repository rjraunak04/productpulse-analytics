# Growth and customer economics

## What the source supports

The GA4 sample contains observed purchase behaviour and USD revenue. ProductPulse can therefore calculate:

- observed purchase revenue
- revenue per active or purchasing pseudonymous user
- purchase-event frequency
- observed repeat-purchase rate
- observed-window user value
- revenue context by first-user acquisition source/medium
- relative RFM-style behavioural/value segments

## What ProductPulse does not fabricate

The source does not provide a trustworthy marketing-spend ledger, gross margin, contribution margin or verified acquisition cost. Therefore this layer does **not** invent:

- CAC
- ROAS
- payback period
- profit-based LTV

Those metrics require external cost/margin data.

## Observed user value vs LTV

Revenue accumulated for a `user_pseudo_id` during the fixed sample is called **observed purchase revenue/value**, not lifetime value. The three-month window is too short and pseudonymous identity is too limited to claim lifetime customer economics.

## Repeat purchasing

Repeat purchase is defined as at least two purchase events in the observation window. Because purchase-event and transaction integrity are separately audited, this is deliberately called event-based repeat purchasing rather than verified repeat-order behaviour.

## Acquisition-source context

Top-level GA4 `traffic_source` is first-user scoped. Revenue grouped by it answers:

> What observed value is associated with users whose first-user source/medium has this label?

It does not establish session attribution, marketing incrementality, or return on ad spend.

## RFM-style segmentation

RFM scores are quintile-based and relative to this sample. Segments are descriptive prioritization aids, not intrinsic customer labels. Recency is measured against the sample end date.

## Distribution

Value-distribution diagnostics include median and upper percentiles because monetization data is commonly skewed; a mean alone can be misleading.
