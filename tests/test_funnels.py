import pytest

from productpulse.funnels import FunnelStage, summarize_funnel


def test_funnel_summary():
    result=summarize_funnel([
        FunnelStage("start",100),
        FunnelStage("view",80),
        FunnelStage("cart",20),
        FunnelStage("purchase",10),
    ])
    assert result[1]["step_conversion_rate"]==0.8
    assert result[-1]["overall_conversion_rate"]==0.1
    assert result[2]["dropoff_sessions"]==60


def test_empty_funnel():
    assert summarize_funnel([])==[]


def test_funnel_rejects_increasing_counts():
    with pytest.raises(ValueError):
        summarize_funnel([FunnelStage("a",10),FunnelStage("b",11)])


def test_funnel_rejects_negative_counts():
    with pytest.raises(ValueError):
        summarize_funnel([FunnelStage("a",-1)])


def test_zero_entry_has_undefined_conversion():
    result=summarize_funnel([FunnelStage("a",0),FunnelStage("b",0)])
    assert result[0]["overall_conversion_rate"] is None
    assert result[1]["step_conversion_rate"] is None
