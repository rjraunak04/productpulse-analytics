from datetime import datetime, timedelta

import pytest

from productpulse.behaviour.sessions import SessionKey, observed_duration_seconds
from productpulse.behaviour.users import observed_span_days


def test_session_key():
    key = SessionKey("abc", 123)
    assert key.user_pseudo_id == "abc"
    assert key.ga_session_id == 123


@pytest.mark.parametrize("user", ["", "   "])
def test_session_key_rejects_blank_user(user):
    with pytest.raises(ValueError):
        SessionKey(user, 1)


def test_session_key_rejects_negative_id():
    with pytest.raises(ValueError):
        SessionKey("abc", -1)


def test_observed_duration_seconds():
    start = datetime(2026, 1, 1, 12, 0)
    assert observed_duration_seconds(start, start + timedelta(seconds=95)) == 95


def test_duration_rejects_inverted_session():
    start = datetime(2026, 1, 1, 12, 0)
    with pytest.raises(ValueError):
        observed_duration_seconds(start, start - timedelta(seconds=1))


def test_observed_span_days():
    first = datetime(2026, 1, 1, 23, 0)
    last = datetime(2026, 1, 3, 1, 0)
    assert observed_span_days(first, last) == 2
