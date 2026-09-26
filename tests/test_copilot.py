import pandas as pd

from productpulse.copilot import answer_question


def test_funnel_answer_is_grounded_and_caveated():
    datasets = {
        "funnel_summary": pd.DataFrame(
            {"stage_name": ["session_start", "view_item", "purchase"], "sessions": [100, 50, 10]}
        )
    }
    answer = answer_question("Where is the biggest funnel drop?", datasets)
    assert "view_item → purchase" in answer
    assert "80.0%" in answer
    assert "not a causal diagnosis" in answer


def test_experiment_answer_never_claims_causality():
    datasets = {
        "experiment_summary": pd.DataFrame(
            {"variant": ["control", "treatment"], "users": [1000, 1000], "conversion_rate": [0.10, 0.11]}
        )
    }
    answer = answer_question("Did treatment win the experiment?", datasets)
    assert "simulated" in answer
    assert "not causal" in answer


def test_unknown_question_is_bounded():
    answer = answer_question("Who will win the World Cup?", {})
    assert "only answer from ProductPulse" in answer
