import pytest

from productpulse.survival import kaplan_meier


def test_kaplan_meier_basic():
    points=kaplan_meier([(1,2,0),(2,1,1)])
    assert points[0].at_risk==4
    assert points[0].survival==pytest.approx(0.5)
    assert points[1].at_risk==2
    assert points[1].survival==pytest.approx(0.25)


def test_kaplan_meier_empty():
    assert kaplan_meier([])==[]


def test_kaplan_meier_sorts_times():
    assert [p.time for p in kaplan_meier([(2,0,1),(1,1,0)])]==[1,2]


def test_kaplan_meier_rejects_duplicate_times():
    with pytest.raises(ValueError):
        kaplan_meier([(1,1,0),(1,0,1)])


def test_kaplan_meier_rejects_negative_input():
    with pytest.raises(ValueError):
        kaplan_meier([(-1,1,0)])
