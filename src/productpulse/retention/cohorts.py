"""Pure retention semantics used to validate/report SQL outputs."""

from productpulse.metrics.ratios import safe_ratio


def retention_rate(retained_users: int, cohort_size: int) -> float | None:
    if retained_users < 0 or cohort_size < 0:
        raise ValueError("counts cannot be negative")
    if retained_users > cohort_size:
        raise ValueError("retained users cannot exceed cohort size")
    return safe_ratio(retained_users,cohort_size)


def classify_lifecycle(week_number: int, gap_from_prior_active_week: int | None) -> str:
    if week_number < 0:
        raise ValueError("week_number cannot be negative")
    if week_number == 0:
        return "new_observed"
    if gap_from_prior_active_week is None:
        raise ValueError("returning activity requires a prior active week")
    if gap_from_prior_active_week <= 0:
        raise ValueError("active-week gap must be positive")
    return "retained" if gap_from_prior_active_week == 1 else "resurrected"
