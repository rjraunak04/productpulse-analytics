# Statistical experimentation framework

## Critical disclosure

The GA4 public sample does **not** provide ProductPulse with a verified randomized A/B experiment assignment. Step 8 therefore creates a deterministic **simulated assignment layer solely to demonstrate the mechanics of an experimentation pipeline**.

Observed GA4 outcomes are real records from the public sample; treatment/control assignment is synthetic. Results from this demo must not be presented as evidence that a product change caused an outcome.

## Randomization unit

The demo randomizes at `user_pseudo_id` level so the same pseudonymous user cannot appear in both variants. Assignment uses a deterministic hash and fixed seed, making it reproducible.

## Analysis sequence

1. validate assignment counts
2. run sample-ratio-mismatch (SRM) check
3. aggregate the primary binary metric by variant
4. estimate control/treatment rates
5. calculate absolute and relative uplift
6. calculate a confidence interval for absolute uplift
7. run a two-sided difference-in-proportions test
8. compare effect with the minimum practical uplift
9. inspect guardrail metrics
10. communicate statistical and practical significance separately

## SRM

SRM tests whether observed assignment proportions are inconsistent with the intended allocation. A severe imbalance can indicate broken assignment, logging or eligibility and should be investigated before reading experiment outcomes.

The demo uses a stricter SRM alpha of 0.01.

## Primary metric

The demonstration primary metric is user-level purchase conversion.

## Guardrail

Begin-checkout rate is included as a demonstration guardrail. In a real experiment, guardrails must be chosen before reading results and should represent plausible harm or system/business constraints.

## Statistical vs practical significance

A small effect can be statistically detectable but operationally irrelevant. ProductPulse therefore reports:

- p-value / confidence interval
- absolute uplift
- relative uplift
- whether absolute uplift reaches a pre-declared practical threshold

No automatic ship/no-ship recommendation is encoded.

## Power and MDE

The Python module provides an approximate two-arm binary sample-size planner from baseline rate and absolute minimum detectable effect (MDE). Planning belongs before the experiment whenever possible.

## Limitations

The v1 binary analyzer uses large-sample normal approximations and a 95% CI contract. Production experimentation may require exact methods, variance reduction, sequential-testing controls, clustering corrections, multiple-testing adjustment or specialized metric estimators.
