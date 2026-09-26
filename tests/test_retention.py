import pytest

from productpulse.retention import classify_lifecycle,retention_rate


def test_retention_rate():
    assert retention_rate(25,100)==0.25
    assert retention_rate(0,100)==0.0
    assert retention_rate(0,0) is None


def test_retention_rejects_impossible_counts():
    with pytest.raises(ValueError):
        retention_rate(11,10)
    with pytest.raises(ValueError):
        retention_rate(-1,10)


def test_lifecycle_states():
    assert classify_lifecycle(0,None)=="new_observed"
    assert classify_lifecycle(1,1)=="retained"
    assert classify_lifecycle(4,3)=="resurrected"


def test_lifecycle_rejects_invalid_inputs():
    with pytest.raises(ValueError):
        classify_lifecycle(-1,None)
    with pytest.raises(ValueError):
        classify_lifecycle(2,None)
    with pytest.raises(ValueError):
        classify_lifecycle(2,0)
