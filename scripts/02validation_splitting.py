import pandas as pd
import numpy as np
import click
import os
from sklearn.model_selection import train_test_split

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

    # -----------------------------
    # BASIC VALIDATION (Python only)
    # -----------------------------

    # Numeric ranges
    if not iris["petal width"].between(0, 5).all():
        print("WARNING: petal width outside expected range.")

    if not iris["petal length"].between(1, 8).all():
        print("WARNING: petal length outside expected range.")

    if not iris["sepal width"].between(2, 5).all():
        print("WARNING: sepal width outside expected range.")

    if not iris["sepal length"].between(4, 8).all():
        print("WARNING: sepal length outside expected range.")

    # Column existence check
    required_cols = colnames
    for c in required_cols:
        if c not in iris.columns:
            print(f"WARNING: Missing required column {c}")

    # File extension check
    _, ext = os.path.splitext(raw_data)
    if ext.lower() != ".data":
        print(f"WARNING: Expected .data file but got {ext}")

    # Missing values check
    if iris.isnull().any().any():
        print("WARNING: Dataset contains NA/null values.")

    # Data type check
    expected_dtypes = {
        "sepal length": "float64",
        "sepal width": "float64",
        "petal length": "float64",
        "petal width": "float64",
        "class": "object",
    }

    for col, expected in expected_dtypes.items():
        if str(iris[col].dtype) != expected:
            print(f"WARNING: Column '{col}' dtype '{iris[col].dtype}', expected '{expected}'")

    # Save validated dataset
    os.makedirs(data_to, exist_ok=True)
    iris.to_csv(os.path.join(data_to, "iris_validated.csv"), index=False)

    # -----------------------------
    # TRAIN–TEST SPLIT
    # -----------------------------
    iris_train, iris_test = train_test_split(
        iris, test_size=0.2, random_state=seed
    )

    iris_train.to_csv(os.path.join(data_to, "iris_train.csv"), index=False)
    iris_test.to_csv(os.path.join(data_to, "iris_test.csv"), index=False)

    # Create feature/target matrices
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
