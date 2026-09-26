"""Small deterministic quality evaluators.

SQL computes source observations. These functions turn observations into explicit
PASS/FAIL results without embedding BigQuery credentials in the package.
"""

from dataclasses import asdict, dataclass
from typing import Any


@dataclass(frozen=True)
class CheckResult:
    check_id: str
    name: str
    status: str
    observed: Any
    expected: str
    severity: str

    def to_dict(self) -> dict[str, Any]:
        return asdict(self)


def evaluate_zero_expected(
    check_id: str, name: str, observed: int, severity: str = "error"
) -> CheckResult:
    if observed < 0:
        raise ValueError("observed count cannot be negative")
    return CheckResult(
        check_id=check_id,
        name=name,
        status="PASS" if observed == 0 else "FAIL",
        observed=observed,
        expected="0",
        severity=severity,
    )


def evaluate_presence(
    check_id: str, name: str, present: bool, severity: str = "error"
) -> CheckResult:
    return CheckResult(
        check_id=check_id,
        name=name,
        status="PASS" if present else "FAIL",
        observed=present,
        expected="present",
        severity=severity,
    )
