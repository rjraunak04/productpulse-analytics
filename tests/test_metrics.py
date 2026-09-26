import pytest

from productpulse.metrics import WeeklyProductMetrics, safe_ratio


def test_safe_ratio():
    assert safe_ratio(1,4)==0.25
    assert safe_ratio(0,4)==0.0
    assert safe_ratio(4,0) is None


def test_safe_ratio_rejects_negative_denominator():
    with pytest.raises(ValueError):
        safe_ratio(1,-1)


def test_weekly_activation_rate():
    metrics=WeeklyProductMetrics(100,20,25,500.0)
    assert metrics.activation_rate==0.2
    assert metrics.revenue_per_active_user==5.0
    assert metrics.average_purchase_value==20.0


def test_weekly_metrics_reject_invalid_activation():
    with pytest.raises(ValueError):
        WeeklyProductMetrics(10,11,11,100.0)


def test_weekly_metrics_reject_negative_count():
    with pytest.raises(ValueError):
        WeeklyProductMetrics(-1,0,0,0.0)


def test_zero_denominator_properties_are_none():
    metrics=WeeklyProductMetrics(0,0,0,0.0)
    assert metrics.activation_rate is None
    assert metrics.revenue_per_active_user is None
    assert metrics.average_purchase_value is None
