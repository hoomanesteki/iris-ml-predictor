import pandas as pd
import numpy as np
import click
import os
from sklearn.model_selection import train_test_split


def split_data(df, test_size=0.2, random_state=123):
    """
    Split a dataframe into train and test sets.

    Parameters
    ----------
    df : pandas.DataFrame
        Input dataframe.
    test_size : float
        Proportion of the dataset to include in the test split.
    random_state : int
        Random seed for reproducibility.

    Returns
    -------
    train : pandas.DataFrame
        Training set.
    test : pandas.DataFrame
        Test set.
    """
    train, test = train_test_split(
        df, test_size=test_size, random_state=random_state
    )
    return train, test


@click.command()
@click.option('--raw_data', type=str, help="Path to raw data")
@click.option('--data_to', type=str, help="Path to directory where processed data will be written to")
@click.option('--seed', type=int, help="Random seed", default=123)
def main(raw_data, data_to, seed):
    """
    Validate IRIS data and split into train/test sets.
    """

    colnames = [
        "sepal length",
        "sepal width",
        "petal length",
        "petal width",
        "class"
    ]

    iris = pd.read_csv(raw_data, names=colnames, header=None)

    

    if not iris["petal width"].between(0, 5).all():
        print("WARNING: petal width outside expected range.")

    if not iris["petal length"].between(1, 8).all():
        print("WARNING: petal length outside expected range.")

    if not iris["sepal width"].between(2, 5).all():
        print("WARNING: sepal width outside expected range.")

    if not iris["sepal length"].between(4, 8).all():
        print("WARNING: sepal length outside expected range.")

    required_cols = colnames
    for c in required_cols:
        if c not in iris.columns:
            print(f"WARNING: Missing required column {c}")

    _, ext = os.path.splitext(raw_data)
    if ext.lower() != ".data":
        print(f"WARNING: Expected .data file but got {ext}")

    if iris.isnull().any().any():
        print("WARNING: Dataset contains NA/null values.")

    expected_dtypes = {
        "sepal length": "float64",
        "sepal width": "float64",
        "petal length": "float64",
        "petal width": "float64",
        "class": "object",
    }

    for col, expected in expected_dtypes.items():
        if str(iris[col].dtype) != expected:
            print(
                f"WARNING: Column '{col}' dtype '{iris[col].dtype}', expected '{expected}'"
            )

    # Save validated dataset
    os.makedirs(data_to, exist_ok=True)
    iris.to_csv(os.path.join(data_to, "iris_validated.csv"), index=False)

    # -----------------------------
    # TRAIN–TEST SPLIT (TESTABLE)
    # -----------------------------
    iris_train, iris_test = split_data(
        iris, test_size=0.2, random_state=seed
    )

    iris_train.to_csv(os.path.join(data_to, "iris_train.csv"), index=False)
    iris_test.to_csv(os.path.join(data_to, "iris_test.csv"), index=False)

    X_train = iris_train.drop(columns=['class'])
    y_train = iris_train[['class']]

    X_test = iris_test.drop(columns=['class'])
    y_test = iris_test[['class']]

    X_train.to_csv(os.path.join(data_to, "X_train.csv"), index=False)
    y_train.to_csv(os.path.join(data_to, "y_train.csv"), index=False)
    X_test.to_csv(os.path.join(data_to, "X_test.csv"), index=False)
    y_test.to_csv(os.path.join(data_to, "y_test.csv"), index=False)


if __name__ == '__main__':
    main()
