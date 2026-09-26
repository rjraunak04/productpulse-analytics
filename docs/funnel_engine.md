# Ordered conversion funnel engine

## Canonical funnel

`session_start → view_item → add_to_cart → begin_checkout → purchase`

The entity is a valid GA4 session identified by `user_pseudo_id + ga_session_id`.

## Why ordered matching matters

A session-level presence flag only says that two event types occurred somewhere in the session. It does not prove the intended journey order. The funnel engine therefore searches for the first qualifying next-stage timestamp **after the previously matched stage**.

Intermediate unrelated events are allowed. A user does not need to generate only the five funnel events.

## Entry population

A session enters the funnel only when it contains `session_start`. Sessions without a valid composite session key remain outside this model and are already measured by the behavioural reconciliation layer.

## Metrics

For each stage:

- sessions reaching the stage
- conversion from the immediately previous stage
- conversion from funnel entry
- absolute session drop-off

Timing analysis measures median elapsed seconds between successfully matched adjacent stages.

## Segmentation

The first implemented segment is device category. Segment values are anchored to the session-start event so a changing field cannot move a session between groups mid-journey. The contract also reserves country and first-user acquisition dimensions for later analysis.

First-user source/medium remain acquisition context and are never presented as session attribution.

## Interpretation boundary

This funnel describes observed event sequences. It does not establish why a user dropped, and differences between segments are descriptive until an appropriate statistical/experimental design supports stronger claims.
