# Initial data contract

This is a **source-facing contract**, not a guarantee that every optional field is populated.

| Field | Intended type | Required for foundation | Purpose |
|---|---|---:|---|
| event_date | DATE after staging | yes | calendar analysis |
| event_ts | TIMESTAMP | yes | event ordering |
| event_name | STRING | yes | behavioural vocabulary |
| user_pseudo_id | STRING | quality-measured | behavioural identity |
| user_id | STRING | no | optional known-user identifier |
| user_first_touch_ts | TIMESTAMP | no | acquisition/tenure context |
| platform | STRING | no | platform segmentation |
| device_category | STRING | no | device segmentation |
| country | STRING | no | geographic segmentation |
| first_user_source | STRING | no | first-user acquisition source |
| first_user_medium | STRING | no | first-user acquisition medium |
| transaction_id | STRING | no | ecommerce transaction trace |
| purchase_revenue_in_usd | FLOAT64 | no | purchase value |
| ga_session_id | INT64 | coverage-dependent | session reconstruction |
| ga_session_number | INT64 | coverage-dependent | session sequence |

## Contract policy

Fields marked quality-measured are not silently dropped when null. Step 3 will quantify their coverage and define thresholds. Optional dimensions may be excluded from downstream segmentation when obfuscation makes them unreliable.
