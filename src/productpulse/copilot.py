"""Grounded conversational analytics for ProductPulse."""

from __future__ import annotations

import re
from collections.abc import Mapping

import pandas as pd


def _fmt_int(value: object) -> str:
    return f"{int(float(value)):,}"


def _fmt_pct(value: object) -> str:
    return f"{float(value):.1%}"


def _funnel_answer(df: pd.DataFrame) -> str:
    if df.empty:
        return "The validated funnel export is unavailable."
    work = df.copy()
    work["sessions"] = pd.to_numeric(work["sessions"], errors="coerce")
    rows = list(work.dropna(subset=["sessions"])[["stage_name", "sessions"]].itertuples(index=False, name=None))
    drops = []
    for (left_name, left), (right_name, right) in zip(rows, rows[1:], strict=False):
        if left > 0:
            drops.append((left_name, right_name, 1 - right / left))
    journey = " → ".join(f"{name}: {_fmt_int(count)}" for name, count in rows)
    if not drops:
        return f"Ordered funnel sessions are {journey}."
    biggest = max(drops, key=lambda item: item[2])
    return (
        f"Ordered funnel sessions are {journey}. The largest relative drop is "
        f"{biggest[0]} → {biggest[1]} at {_fmt_pct(biggest[2])}. "
        "This is descriptive journey loss, not a causal diagnosis."
    )


def _retention_answer(df: pd.DataFrame) -> str:
    if df.empty or not {"week_number", "retention_rate"}.issubset(df.columns):
        return "The validated retention export is unavailable or incomplete."
    work = df.copy()
    work["week_number"] = pd.to_numeric(work["week_number"], errors="coerce")
    work["retention_rate"] = pd.to_numeric(work["retention_rate"], errors="coerce")
    later = work.dropna(subset=["week_number", "retention_rate"])
    later = later[later["week_number"] > 0]
    if later.empty:
        return "Only W0 retention is observable in the current export."
    by_week = later.groupby("week_number", as_index=False)["retention_rate"].mean()
    first = by_week.sort_values("week_number").iloc[0]
    return (
        f"Across observable cohorts, mean W{int(first['week_number'])} retention is "
        f"{_fmt_pct(first['retention_rate'])}. Future cohort cells that are not yet "
        "observable are right-censored and must not be treated as 0% retention."
    )


def _experiment_answer(df: pd.DataFrame) -> str:
    warning = (
        "Important: variant assignment is deterministic and simulated for framework "
        "demonstration, so differences are not causal product effects."
    )
    if df.empty or not {"variant", "users", "conversion_rate"}.issubset(df.columns):
        return f"The experiment export is unavailable or incomplete. {warning}"
    parts = [
        f"{row.variant}: {_fmt_int(row.users)} users, {_fmt_pct(row.conversion_rate)} conversion"
        for row in df.itertuples(index=False)
    ]
    return f"{'; '.join(parts)}. {warning}"


def _inactivity_answer(df: pd.DataFrame) -> str:
    if df.empty or not {"inactivity_state", "users", "share"}.issubset(df.columns):
        return "The validated inactivity export is unavailable or incomplete."
    parts = [
        f"{row.inactivity_state}: {_fmt_int(row.users)} ({_fmt_pct(row.share)})"
        for row in df.itertuples(index=False)
    ]
    return f"{'; '.join(parts)}. These are observed inactivity states, not permanent churn labels."


def _economics_answer(df: pd.DataFrame) -> str:
    if df.empty or not {"week_start", "purchase_revenue_usd"}.issubset(df.columns):
        return "The validated revenue export is unavailable or incomplete."
    latest = df.sort_values("week_start").iloc[-1]
    text = (
        f"In the latest exported week ({latest['week_start']}), purchase revenue is "
        f"USD {float(latest['purchase_revenue_usd']):,.2f}"
    )
    if "revenue_per_active_user" in df:
        text += f" and revenue per active user is USD {float(latest['revenue_per_active_user']):,.2f}"
    return text + ". Observed-window revenue is not lifetime value."


def _overview_answer(datasets: Mapping[str, pd.DataFrame]) -> str:
    weekly = datasets.get("weekly_product_kpis", pd.DataFrame())
    if weekly.empty:
        return "The weekly KPI export is unavailable."
    latest = weekly.sort_values("week_start").iloc[-1]
    return (
        f"Latest exported week ({latest['week_start']}): "
        f"{_fmt_int(latest['weekly_active_users'])} weekly active users, "
        f"{_fmt_int(latest['weekly_activated_users'])} weekly activated users, and "
        f"{_fmt_pct(latest['weekly_activation_rate'])} activation. "
        "Use the funnel, retention, economics and inactivity views for diagnosis."
    )


def answer_question(question: str, datasets: Mapping[str, pd.DataFrame]) -> str:
    """Answer supported product-analytics questions from validated aggregates."""
    q = re.sub(r"\s+", " ", question.strip().lower())
    if not q:
        return "Ask about activation, funnel, retention, experimentation, revenue, or inactivity."
    if any(term in q for term in ("funnel", "drop", "cart", "checkout")):
        return _funnel_answer(datasets.get("funnel_summary", pd.DataFrame()))
    if any(term in q for term in ("retention", "cohort", "return")):
        return _retention_answer(datasets.get("retention_matrix", pd.DataFrame()))
    if any(term in q for term in ("experiment", "variant", "control", "treatment", "a/b", "ab test")):
        return _experiment_answer(datasets.get("experiment_summary", pd.DataFrame()))
    if any(term in q for term in ("revenue", "economics", "value", "monetization")):
        return _economics_answer(datasets.get("weekly_revenue_metrics", pd.DataFrame()))
    if any(term in q for term in ("inactive", "inactivity", "churn", "survival")):
        return _inactivity_answer(datasets.get("inactivity_summary", pd.DataFrame()))
    if any(term in q for term in ("overview", "summary", "activation", "wau", "active user", "north star")):
        return _overview_answer(datasets)
    return (
        "I only answer from ProductPulse's validated aggregate outputs. Try activation, "
        "the ordered funnel, cohort retention, the simulated experiment, revenue, or inactivity."
    )
