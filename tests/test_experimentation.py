import pytest

from productpulse.experimentation import (
    analyze_binary_metric,
    approximate_sample_size_per_arm,
    sample_ratio_mismatch,
)


def test_binary_metric_detects_positive_uplift():
    result = analyze_binary_metric(100, 1000, 130, 1000, minimum_practical_uplift=0.02)
    assert result.absolute_uplift == pytest.approx(0.03)
    assert result.relative_uplift == pytest.approx(0.3)
    assert result.practically_significant is True
    assert result.ci_low < result.absolute_uplift < result.ci_high


def test_binary_metric_rejects_bad_counts():
    with pytest.raises(ValueError):
        analyze_binary_metric(11, 10, 1, 10)


def test_srm_balanced_allocation():
    result = sample_ratio_mismatch(500, 500)
    assert result["chi_square"] == pytest.approx(0.0)
    assert result["p_value"] > 0.05
    assert result["srm_detected"] is False


def test_srm_detects_large_imbalance():
    assert sample_ratio_mismatch(700, 300)["srm_detected"] is True


def test_power_increases_with_smaller_mde():
    assert approximate_sample_size_per_arm(0.10, 0.01) > approximate_sample_size_per_arm(0.10, 0.03)
