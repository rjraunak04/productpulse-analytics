"""Typed weekly product metric record."""

from dataclasses import dataclass

from .ratios import safe_ratio


@dataclass(frozen=True)
class WeeklyProductMetrics:
    active_users: int
    activated_users: int
    purchase_events: int
    purchase_revenue_usd: float

    def __post_init__(self) -> None:
        values = (self.active_users,self.activated_users,self.purchase_events)
        if any(value < 0 for value in values):
            raise ValueError("metric counts cannot be negative")
        if self.activated_users > self.active_users:
            raise ValueError("activated users cannot exceed active users")

    @property
    def activation_rate(self) -> float | None:
        return safe_ratio(self.activated_users,self.active_users)

    @property
    def revenue_per_active_user(self) -> float | None:
        return safe_ratio(self.purchase_revenue_usd,self.active_users)

    @property
    def average_purchase_value(self) -> float | None:
        return safe_ratio(self.purchase_revenue_usd,self.purchase_events)
