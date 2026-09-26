from pathlib import Path

import pandas as pd
import pytest

from productpulse.app_data import load_csv, require_columns


def test_load_missing_csv_returns_empty(tmp_path: Path):
    assert load_csv(tmp_path/"missing.csv").empty


def test_load_csv(tmp_path: Path):
    path=tmp_path/"x.csv"
    path.write_text("a,b\n1,2\n",encoding="utf-8")
    assert load_csv(path).to_dict("records")==[{"a":1,"b":2}]


def test_require_columns():
    require_columns(pd.DataFrame({"a":[1],"b":[2]}),{"a"})
    with pytest.raises(ValueError):
        require_columns(pd.DataFrame({"a":[1]}),{"a","b"})
