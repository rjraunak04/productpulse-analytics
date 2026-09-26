# Inactivity and time-to-return analysis

## Question

After an observed active week, how long until the same pseudonymous user is observed active again?

This is a **time-to-next-activity** problem. It is more defensible than labelling every user who disappears before the dataset ends as permanently churned.

## Event and censoring

- origin: an observed active week
- event: next observed active week
- duration: weeks from origin to next activity
- right-censored: no later activity is observed before the fixed dataset endpoint

A censored interval means the return time is unknown beyond the available follow-up. It does not mean the user never returned.

## Kaplan-Meier

The repository creates event/censor counts by duration and provides a small tested Kaplan-Meier estimator. The survival function here represents the probability that the next observed return has **not yet occurred** beyond a given duration, conditional on the observed risk set.

## Inactivity states

At the observation endpoint users are described as:

- active this week
- one week inactive
- multiweek inactive

These are descriptive states, not permanent churn labels.

## Important limitation

The sample is only a bounded historical window. Early activity may predate the sample and future activity may occur after it. `user_pseudo_id` is also a pseudonymous client identifier rather than a verified cross-device customer.

## Interpretation

Survival/inactivity patterns can identify where return behaviour weakens and can inform lifecycle hypotheses. They do not, by themselves, establish why users stop returning or prove a causal churn driver.
