"""User-window helpers."""

from datetime import datetime


def observed_span_days(first_seen: datetime, last_seen: datetime) -> int:
    if last_seen < first_seen:
        raise ValueError("last_seen cannot precede first_seen")
    return (last_seen.date() - first_seen.date()).days
