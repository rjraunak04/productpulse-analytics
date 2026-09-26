# Step 8 runbook — experimentation

## Demonstration workflow

1. `00_simulated_assignment.sql`
2. `01_experiment_outcomes.sql`
3. `02_assignment_balance.sql`
4. `03_binary_metric_summary.sql`
5. pass variant counts to the Python SRM check
6. pass primary-metric successes/sample sizes to `analyze_binary_metric`
7. inspect the guardrail separately
8. document both statistical and practical significance

## Code gate

`ruff check src tests`

`pytest -q`

## Required disclosure

Any screenshot, README result or interview explanation based on this layer must state:

**Experiment assignment is simulated for framework demonstration; it is not an observed randomized Google Merchandise Store experiment.**

## Acceptance criteria

- assignment is deterministic and user-level
- simulated assignment is unmistakably disclosed
- SRM check exists
- absolute/relative uplift exist
- confidence interval and two-sided p-value exist
- practical threshold is predeclared in config
- binary sample-size/MDE planning exists
- guardrail metric is separated from primary metric
- statistical and practical significance are not conflated
- no causal claim is made from the demo result
