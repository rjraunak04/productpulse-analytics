# App-ready analytical exports

The Streamlit application reads small CSV outputs from this directory. Raw GA4 data must never be committed here.

Expected filenames:

- `weekly_product_kpis.csv`
- `funnel_summary.csv`
- `retention_matrix.csv`
- `experiment_summary.csv`
- `weekly_revenue_metrics.csv`
- `inactivity_summary.csv`

These outputs are generated from the version-controlled analytical queries. Because live BigQuery execution is environment-specific, the repository does not fabricate example results.

For a public deployment, provide validated aggregate exports or connect a secure warehouse-backed export process. Never commit credentials.
