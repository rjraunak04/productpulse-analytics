"""Data-quality utilities for ProductPulse."""

from .checks import CheckResult, evaluate_zero_expected, evaluate_presence

__all__ = ["CheckResult", "evaluate_zero_expected", "evaluate_presence"]
