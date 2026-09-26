# Contributing

ProductPulse v1 is portfolio-frozen after release. Changes should fix defects, improve reproducibility, or clarify documentation rather than expand scope.

## Local quality gate

1. Create a Python 3.11+ virtual environment.
2. Install: `pip install -e ".[dev]"`
3. Run: `ruff check src tests`
4. Run: `pytest -q`

For the decision app, additionally install `requirements-app.txt`.

## Analytics rules

- never commit raw GA4 data or credentials
- never fabricate query outputs
- preserve pseudonymous-identity wording
- keep ordered funnel logic separate from presence flags
- preserve censoring in retention/survival analysis
- disclose simulated experiment assignment
- do not introduce CAC/ROAS/LTV without defensible external inputs
