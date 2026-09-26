import pytest

from productpulse.quality.checks import evaluate_presence, evaluate_zero_expected
from productpulse.quality.report import build_report


def test_zero_expected_passes_at_zero():
    result = evaluate_zero_expected("Q001", "null_date", 0)
    assert result.status == "PASS"


def test_zero_expected_fails_above_zero():
    result = evaluate_zero_expected("Q001", "null_date", 2)
    assert result.status == "FAIL"


def test_zero_expected_rejects_negative_count():
    with pytest.raises(ValueError):
        evaluate_zero_expected("Q001", "null_date", -1)


def test_presence():
    assert evaluate_presence("Q011", "purchase", True).status == "PASS"
    assert evaluate_presence("Q011", "purchase", False).status == "FAIL"


def test_warning_failure_does_not_block_report():
    warning = evaluate_zero_expected("Q005", "missing_user", 3, severity="warn")
    report = build_report([warning])
    assert report["status"] == "PASS"
    assert report["failures"] == 1
    assert report["blocking_failures"] == 0


def test_error_failure_blocks_report():
    failure = evaluate_zero_expected("Q001", "null_date", 1, severity="error")
    report = build_report([failure])
    assert report["status"] == "FAIL"
    assert report["blocking_failures"] == 1
