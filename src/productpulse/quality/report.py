"""Serialize quality results into a compact machine-readable report."""

import json
from pathlib import Path

from .checks import CheckResult


def build_report(results: list[CheckResult]) -> dict:
    failures = [r for r in results if r.status == "FAIL"]
    blocking = [r for r in failures if r.severity == "error"]
    return {
        "status": "FAIL" if blocking else "PASS",
        "checks": len(results),
        "failures": len(failures),
        "blocking_failures": len(blocking),
        "results": [r.to_dict() for r in results],
    }


def write_report(results: list[CheckResult], path: str | Path) -> None:
    destination = Path(path)
    destination.parent.mkdir(parents=True, exist_ok=True)
    destination.write_text(json.dumps(build_report(results), indent=2), encoding="utf-8")
