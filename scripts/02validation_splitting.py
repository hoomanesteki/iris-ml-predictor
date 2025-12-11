import pandas as pd
import numpy as np
import pointblank as pb
import click
import os
from sklearn.model_selection import train_test_split

@click.command()
@click.option('--raw_data', type=str, help="Path to raw data")
@click.option('--data_to', type=str, help="Path to directory where processed data will be written to")
@click.option('--seed', type=int, help="Random seed", default=123)

def main(raw_data, data_to, seed):
    '''
    This function conducts a series of validation steps on the columns of iris.csv. It then splits the data into train and test based on a 80-20 split.
    
    :param raw_data: Path to directory where raw data is stored
    :param data_to: Path to directory where validated and split data is to be saved
    :param seed: Seed to be set for reproducibility
    '''

    colnames = [
        "sepal length",
        "sepal width",
        "petal length",
        "petal width",
        "class"
    ]

    iris = pd.read_csv(raw_data, names=colnames, header=None)

    # Data validation
    validation = (
        pb.Validate(iris)
        .col_vals_between(columns="petal width", left=0, right=5)
        .col_vals_between(columns="petal length", left=1, right=8)
        .col_vals_between(columns="sepal width", left=2, right=5)
        .col_vals_between(columns="sepal length", left=4, right=8)
        .col_exists(columns=["sepal length", "sepal width","petal length","petal width","class"])
        .interrogate()
    )
    validation
    iris_validated = validation.get_sundered_data(type="pass")
    
    # Check for correct file type
    

    # Check for empty observations
    # Check for correct data types in each column


    #save full validated data to directory
    iris_validated.to_csv(os.path.join(data_to, "iris_validated.csv"), index=False)

    #split the data into train and test
    iris_train, iris_test = train_test_split(
        iris, test_size=0.2, random_state=seed
    )

    iris_train.to_csv(os.path.join(data_to, "iris_train.csv"), index=False)
    iris_test.to_csv(os.path.join(data_to, "iris_test.csv"), index=False)

    #create X_train, y_train, X_test, y_test
    X_train, X_test = iris_train.drop(columns=['class']), iris_test.drop(columns=['class'])
    y_train, y_test = iris_train[['class']].copy(), iris_test[['class']].copy()

    #save X_train, y_train, X_test, y_test to directory
    X_train.to_csv(os.path.join(data_to, "X_train.csv"), index=False)
    y_train.to_csv(os.path.join(data_to, "y_train.csv"), index=False)
    X_test.to_csv(os.path.join(data_to, "X_test.csv"), index=False)
    y_test.to_csv(os.path.join(data_to, "y_test.csv"), index=False)

if __name__ == '__main__':
    main()