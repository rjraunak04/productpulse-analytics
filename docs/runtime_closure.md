# Runtime closure

ProductPulse's repository implementation is complete. Runtime closure has four evidence gates:

1. **Warehouse execution** — run the version-controlled BigQuery queries against the public GA4 sample and export validated aggregate CSVs.
2. **Application smoke test** — launch Streamlit using those validated exports and inspect every decision view.
3. **CI proof** — obtain a successful GitHub Actions run for Ruff and pytest on the final commit.
4. **Release** — publish only after the above evidence exists.

## Deployment

The repository includes a Railway-compatible Procfile:

`web: streamlit run app/streamlit_app.py --server.address=0.0.0.0 --server.port=$PORT`

The app is safe to deploy before warehouse exports: it shows explicit empty states instead of fabricated results. A populated public portfolio deployment should wait for validated exports.

## BigQuery access dependency

Actual warehouse execution requires an authenticated Google Cloud project with permission to run BigQuery jobs. The public source can be read without copying raw data, but query jobs still execute under a user project.

Never replace this evidence gate with invented CSVs or screenshots.
