"""App data-contract helpers."""

from pathlib import Path

import pandas as pd


def load_csv(path: str | Path) -> pd.DataFrame:
    path=Path(path)
    if not path.exists():
        return pd.DataFrame()
    return pd.read_csv(path)


def require_columns(frame: pd.DataFrame,required: set[str]) -> None:
    missing=required-set(frame.columns)
    if missing:
        raise ValueError(f"missing required columns: {sorted(missing)}")
