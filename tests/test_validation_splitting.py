import pandas as pd
from scripts import split_data


def test_split_is_reproducible():
    df = pd.DataFrame({
        "a": range(50),
        "b": range(50)
    })

    train1, test1 = split_data(df, test_size=0.2, random_state=42)
    train2, test2 = split_data(df, test_size=0.2, random_state=42)

    pd.testing.assert_frame_equal(train1, train2)
    pd.testing.assert_frame_equal(test1, test2)


def test_split_preserves_columns():
    df = pd.DataFrame({
        "x": range(20),
        "y": range(20),
        "z": range(20)
    })

    train, test = split_data(df)

    assert list(train.columns) == list(df.columns)
    assert list(test.columns) == list(df.columns)
