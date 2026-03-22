from pokeagent_datasets import get_dataset, SOURCES


def pull_datasets():
    for name in SOURCES:
        print(f"Pulling {name}...")
        ds = get_dataset(name)
        print(f"  {name}: {len(ds)} rows")


if __name__ == "__main__":
    pull_datasets()
