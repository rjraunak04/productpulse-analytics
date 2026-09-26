"""Safe ratio semantics shared by ProductPulse metrics."""

from numbers import Real


def safe_ratio(numerator: Real, denominator: Real) -> float | None:
    if denominator < 0:
        raise ValueError("denominator cannot be negative")
    if denominator == 0:
        return None
    return float(numerator / denominator)
