import pytest

from productpulse.experimentation import (
    analyze_binary_metric,\n    approximate_sample_size_per_arm,\n    sample_ratio_mismatch,
)


def test_binary_analysis_positive_lift():
    r=analyze_binary_metric(100,1000,130,1000,minimum_practical_uplift=0.02)
    assert r.control_rate==0.1
    assert r.treatment_rate==0.13
    assert r.absolute_uplift==pytest.approx(0.03)
    assert r.relative_uplift==pytest.approx(0.3)
    assert r.practically_significant is True
    assert 0<=r.p_value<=1


def test_binary_analysis_rejects_bad_counts():
    with pytest.raises(ValueError):
        analyze_binary_metric(11,10,1,10)


def test_zero_control_rate_relative_uplift_is_none():
    r=analyze_binary_metric(0,100,1,100)
    assert r.relative_uplift is None


def test_srm_balanced_assignment():
    r=sample_ratio_mismatch(500,500)
    assert r["srm_detected"] is False
    assert r["p_value"]==pytest.approx(1.0)


def test_srm_detects_large_imbalance():
    assert sample_ratio_mismatch(900,100)["srm_detected"] is True


def test_power_sample_size_behaviour():
    n=approximate_sample_size_per_arm(0.10,0.02)
    assert n>0
    assert approximate_sample_size_per_arm(0.10,0.01)>n


def test_power_rejects_invalid_probability():
    with pytest.raises(ValueError):
        approximate_sample_size_per_arm(0.99,0.02)
