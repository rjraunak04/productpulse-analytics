"""ProductPulse decision application.

The app consumes exported analytical outputs. It intentionally does not query
BigQuery on every UI interaction, keeping the portfolio app cheap and reproducible.
"""

from pathlib import Path
import sys

ROOT_DIR = Path(__file__).resolve().parents[1]
SRC_DIR = ROOT_DIR / "src"
if str(SRC_DIR) not in sys.path:
    sys.path.insert(0, str(SRC_DIR))

import pandas as pd
import streamlit as st

from productpulse.copilot import answer_question

def load_csv(path: str | Path) -> pd.DataFrame:
    """Load an exported aggregate CSV, returning an empty frame when absent."""
    path = Path(path)
    if not path.exists():
        return pd.DataFrame()
    return pd.read_csv(path)

DATA_DIR=ROOT_DIR / "reports" / "app_data"

st.set_page_config(page_title="ProductPulse",page_icon="📈",layout="wide")
st.title("ProductPulse")
st.caption("Product growth, retention, experimentation and customer-value decision workspace")

with st.sidebar:
    st.header("Analysis")
    page=st.radio(
        "View",
        ["Executive overview","Funnel","Retention","Experimentation","Economics","Inactivity","Analytics Copilot"],
    )
    st.divider()
    st.caption("GA4 public sample · 2020-11-01 to 2021-01-31")
    st.caption("Pseudonymous users; observed-window metrics.")

def dataset(name: str) -> pd.DataFrame:
    return load_csv(DATA_DIR/name)

if page=="Executive overview":
    st.subheader("Executive overview")
    st.info("Run the documented export pipeline to populate app-ready analytical outputs.")
    weekly=dataset("weekly_product_kpis.csv")
    if not weekly.empty:
        latest=weekly.sort_values("week_start").iloc[-1]
        c1,c2,c3=st.columns(3)
        c1.metric("Weekly active users",f"{int(latest['weekly_active_users']):,}")
        c2.metric("Weekly activated users",f"{int(latest['weekly_activated_users']):,}")
        c3.metric("Activation rate",f"{latest['weekly_activation_rate']:.1%}")
        st.line_chart(weekly.set_index("week_start")[["weekly_active_users","weekly_activated_users"]])
    st.markdown("**Decision lens:** track activation, diagnose journey loss, then validate retention/value impact.")

elif page=="Funnel":
    st.subheader("Ordered conversion funnel")
    df=dataset("funnel_summary.csv")
    if df.empty:
        st.info("No exported funnel summary found.")
    else:
        st.bar_chart(df.set_index("stage_name")["sessions"])
        st.dataframe(df,use_container_width=True,hide_index=True)
    st.caption("Same-session ordered journey; event-presence flags are not substituted for conversion.")

elif page=="Retention":
    st.subheader("Weekly cohort retention")
    df=dataset("retention_matrix.csv")
    if df.empty:
        st.info("No exported retention matrix found.")
    else:
        st.dataframe(df,use_container_width=True,hide_index=True)
    st.caption("NULL future cells are unobservable follow-up, not zero retention.")

elif page=="Experimentation":
    st.subheader("Experimentation framework")
    st.warning("Assignment is simulated for framework demonstration; this is not an observed randomized Google experiment.")
    df=dataset("experiment_summary.csv")
    if df.empty:
        st.info("No exported experiment summary found.")
    else:
        st.dataframe(df,use_container_width=True,hide_index=True)
    st.markdown("Read SRM, uncertainty, practical significance and guardrails before interpreting variant differences.")

elif page=="Economics":
    st.subheader("Observed customer-value economics")
    df=dataset("weekly_revenue_metrics.csv")
    if df.empty:
        st.info("No exported weekly revenue metrics found.")
    else:
        st.line_chart(df.set_index("week_start")[["purchase_revenue_usd","revenue_per_active_user"]])
        st.dataframe(df,use_container_width=True,hide_index=True)
    st.caption("Observed value is not LTV. CAC/ROAS/payback are excluded without cost data.")

elif page=="Inactivity":
    st.subheader("Inactivity and time-to-return")
    df=dataset("inactivity_summary.csv")
    if df.empty:
        st.info("No exported inactivity summary found.")
    else:
        st.bar_chart(df.set_index("inactivity_state")["users"])
        st.dataframe(df,use_container_width=True,hide_index=True)
    st.caption("Inactivity and right censoring are not permanent churn labels.")


else:
    st.subheader("ProductPulse Analytics Copilot")
    st.caption("Grounded conversational analytics over validated ProductPulse exports.")
    st.info(
        "The copilot is deliberately bounded to validated aggregate outputs. "
        "It will not invent unavailable metrics or treat the simulated experiment as causal."
    )

    copilot_data = {
        "weekly_product_kpis": dataset("weekly_product_kpis.csv"),
        "funnel_summary": dataset("funnel_summary.csv"),
        "retention_matrix": dataset("retention_matrix.csv"),
        "experiment_summary": dataset("experiment_summary.csv"),
        "weekly_revenue_metrics": dataset("weekly_revenue_metrics.csv"),
        "inactivity_summary": dataset("inactivity_summary.csv"),
    }

    if "copilot_messages" not in st.session_state:
        st.session_state.copilot_messages = [
            {
                "role": "assistant",
                "content": (
                    "Ask me about activation, funnel drop-off, cohort retention, "
                    "the experiment demo, revenue, or inactivity."
                ),
            }
        ]

    for message in st.session_state.copilot_messages:
        with st.chat_message(message["role"]):
            st.markdown(message["content"])

    question = st.chat_input("Ask ProductPulse about the validated analytics...")
    if question:
        st.session_state.copilot_messages.append({"role": "user", "content": question})
        with st.chat_message("user"):
            st.markdown(question)
        answer = answer_question(question, copilot_data)
        st.session_state.copilot_messages.append({"role": "assistant", "content": answer})
        with st.chat_message("assistant"):
            st.markdown(answer)
