"""Minimal Kaplan-Meier estimator from aggregated event/censor counts."""

from dataclasses import dataclass


@dataclass(frozen=True)
class KaplanMeierPoint:
    time: int
    at_risk: int
    events: int
    censored: int
    survival: float


def kaplan_meier(rows: list[tuple[int,int,int]]) -> list[KaplanMeierPoint]:
    """Rows are (time, events, censored), one row per unique non-negative time."""
    if not rows:
        return []
    ordered=sorted(rows,key=lambda x:x[0])
    if len({r[0] for r in ordered})!=len(ordered):
        raise ValueError("times must be unique")
    if any(t<0 or e<0 or c<0 for t,e,c in ordered):
        raise ValueError("times and counts cannot be negative")

    at_risk=sum(e+c for _,e,c in ordered)
    survival=1.0
    output=[]
    for time,events,censored in ordered:
        if events>at_risk:
            raise ValueError("events cannot exceed risk set")
        if at_risk>0:
            survival*=1-events/at_risk
        output.append(KaplanMeierPoint(time,at_risk,events,censored,survival))
        at_risk-=events+censored
        if at_risk<0:
            raise ValueError("events plus censoring exceed risk set")
    return output
