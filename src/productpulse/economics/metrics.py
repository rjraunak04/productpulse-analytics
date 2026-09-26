"""Safe observed-window economics calculations."""

from productpulse.metrics.ratios import safe_ratio


def revenue_per_user(revenue: float,users: int) -> float | None:
    if users<0:
        raise ValueError("users cannot be negative")
    return safe_ratio(revenue,users)


def observed_repeat_purchase_rate(repeat_users: int,purchasing_users: int) -> float | None:
    if repeat_users<0 or purchasing_users<0:
        raise ValueError("counts cannot be negative")
    if repeat_users>purchasing_users:
        raise ValueError("repeat users cannot exceed purchasing users")
    return safe_ratio(repeat_users,purchasing_users)
