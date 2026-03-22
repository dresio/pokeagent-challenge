from pathlib import Path

from datasets import load_dataset

# datasets directory. In the .gitignore so we don't carry multiple GB of data
DATASETS_DIR = Path(__file__).resolve().parent.parent / "datasets"

# Found from https://pokeagentchallenge.com/battling.html under Datasets header
SOURCES = {
    "metamon-raw-replays": "jakegrigsby/metamon-raw-replays",
    "pokechamp": "milkkarten/pokechamp",
}


def get_dataset(name: str, split: str = "train", **kwargs):
    """Load a dataset from HuggingFace, caching parquet files under datasets directory.

    Args:
        name: Key in SOURCES (metamon-raw-replays or pokechamp).
        split: Dataset split to load (default "train").
        **kwargs: Extra arguments forwarded to load_dataset.
    """
    if name not in SOURCES:
        raise ValueError(f"Unknown dataset {name!r}. Choose from: {list(SOURCES)}")

    cache_dir = DATASETS_DIR / name
    return load_dataset(
        SOURCES[name],
        split=split,
        cache_dir=str(cache_dir),
        **kwargs,
    )
