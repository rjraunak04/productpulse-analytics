# Product metric dictionary

## North Star — Weekly Activated Users (WAU-A)

**Definition v1:** distinct `user_pseudo_id` values with at least one `purchase` event during a Monday-based analytical week.

### Why purchase for v1?

The public ecommerce source gives an observable purchase event representing completed value exchange. Earlier ProductPulse documentation intentionally left activation pending source validation. Step 5 now adopts purchase as a conservative, reproducible v1 activation proxy.

This is **not** a claim that every ecommerce product should define activation as purchase. A real product team would validate whether an earlier behaviour predicts durable value and may choose that as activation instead.

## Supporting metrics

**Weekly Active Users (WAU):** distinct pseudonymous users with at least one observed event in the week.

**Weekly Activation Rate:** WAU-A / WAU.

**Observed Sessions:** distinct valid `user_pseudo_id + ga_session_id` sessions anchored to their first observed event week.

**Purchasing Sessions:** observed sessions containing at least one purchase.

**Purchase Session Rate:** purchasing sessions / observed sessions.

**Revenue per Active User:** purchase revenue in USD / WAU.

**Average Purchase Value:** purchase revenue in USD / number of purchase events. This is event-based and is not labelled average order value until transaction integrity has been validated.

**Viewer-to-Cart User Rate:** users with at least one add-to-cart / users with at least one item view in the same analytical week. This is a supporting behavioural ratio, not an ordered funnel conversion.

## Week boundary

Weeks start Monday. Because the source begins and ends mid-week, boundary weeks are explicitly flagged as partial observation weeks and should not be compared naively with full weeks.

## Ratio semantics

Division by zero returns NULL/None rather than zero. Zero can mean an observed rate of zero; NULL means the rate is undefined.

## Scope

All user metrics describe pseudonymous identifiers inside the fixed sample window. They are not verified people and are not lifetime customer metrics.
