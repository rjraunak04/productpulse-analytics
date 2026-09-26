"""Data-quality utilities for ProductPulse."""

from .checks import CheckResult, evaluate_presence, evaluate_zero_expected

__all__ = ["CheckResult", "evaluate_presence", "evaluate_zero_expected"]
