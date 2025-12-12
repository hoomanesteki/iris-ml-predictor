import pandas as pd
from scripts import split_data

def test_split_sizes():
    df = pd.DataFrame({
        "a": range(100),
        "b": range(100)
    })

    train, test = split_data(df, test_size=0.2, random_state=123)

    assert len(train) == 80
    assert len(test) == 20
