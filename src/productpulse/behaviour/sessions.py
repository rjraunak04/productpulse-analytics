"""Session contract helpers."""

from dataclasses import dataclass
from datetime import datetime


@dataclass(frozen=True)
class SessionKey:
    user_pseudo_id: str
    ga_session_id: int

    def __post_init__(self) -> None:
        if not self.user_pseudo_id.strip():
            raise ValueError("user_pseudo_id must be non-empty")
        if self.ga_session_id < 0:
            raise ValueError("ga_session_id must be non-negative")


def observed_duration_seconds(start: datetime, end: datetime) -> int:
    if end < start:
        raise ValueError("session end cannot precede session start")
    return int((end - start).total_seconds())
