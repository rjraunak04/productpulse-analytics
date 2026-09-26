from itertools import pairwise
"""Pure-Python funnel summary logic used for validation/reporting."""

from dataclasses import dataclass

from productpulse.metrics.ratios import safe_ratio


@dataclass(frozen=True)
class FunnelStage:
    name: str
    reached: int


def summarize_funnel(stages: list[FunnelStage]) -> list[dict]:
    if not stages:
        return []
    if any(s.reached < 0 for s in stages):
        raise ValueError("stage counts cannot be negative")
    for previous, current in pairwise(stages):
        if current.reached > previous.reached:
            raise ValueError("ordered funnel stage counts must be non-increasing")

    entry=stages[0].reached
    output=[]
    for index, stage in enumerate(stages):
        previous=stages[index-1].reached if index else None
        output.append({
            "stage": index+1, 
            "stage_name": stage.name, 
            "sessions": stage.reached, 
            "step_conversion_rate": None if previous is None else safe_ratio(stage.reached, previous), 
            "overall_conversion_rate": safe_ratio(stage.reached, entry), 
            "dropoff_sessions": None if previous is None else previous-stage.reached, 
        })
    return output
