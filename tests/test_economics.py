import pytest

from productpulse.economics import observed_repeat_purchase_rate, revenue_per_user


def test_revenue_per_user():
    assert revenue_per_user(500,100)==5.0
    assert revenue_per_user(0,0) is None


def test_revenue_per_user_rejects_negative_users():
    with pytest.raises(ValueError):
        revenue_per_user(10,-1)


def test_repeat_purchase_rate():
    assert observed_repeat_purchase_rate(20,100)==0.2
    assert observed_repeat_purchase_rate(0,0) is None


def test_repeat_purchase_rate_rejects_impossible_counts():
    with pytest.raises(ValueError):
        observed_repeat_purchase_rate(11,10)
