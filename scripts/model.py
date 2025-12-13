import pandas as pd 
from sklearn.tree import DecisionTreeClassifier
import pickle
import os
import click
from sklearn.dummy import DummyClassifier

def create_dir_if_not_exists(directory):
        os.makedirs(directory, exist_ok=True)


def train_model(X, y, seed):
        model = DecisionTreeClassifier(max_depth=3, random_state=seed)
        model.fit(X, y)
        return model

def train_dummy(X, y, seed):
        dummy = DummyClassifier(strategy='stratified',random_state=seed)
        dummy.fit(X, y)
        return dummy

@click.command()
@click.option('--training_data', type=str, help="Path to directory containing training data")
@click.option('--model_to', type=str, help="Path to directory where the model object will be written to")
@click.option('--seed', type=int, help="Random seed", default=123)

def main(training_data, model_to, seed):
        '''
        Fits a Decision Tree Classifier and a DummyClassifier
        onto the training dataset.

        The dummy model serves as a baseline.
        
        :param training_data: Path to directory containing training data
        :param model_to: path to directory where model object will be saved
        :param seed: random_state object
        '''

        #check if model directory exists, if not create it
        create_dir_if_not_exists(model_to)

        #load the data
        X_train = pd.read_csv(os.path.join(training_data, "X_train.csv"))
        y_train = pd.read_csv(os.path.join(training_data, "y_train.csv")).squeeze()

        #Create model object and fit to data
        tree = train_model(X_train, y_train, seed=seed)
        
        dummy = train_dummy(X_train,y_train,seed)

        #save model object as .pkl file and export to directory
        with open(os.path.join(model_to, "tree_model.pkl"), "wb") as f:
                pickle.dump(tree, f)
        
        with open(os.path.join(model_to, "dummy_model.pkl"), "wb") as f:
                pickle.dump(dummy, f)

if __name__ == '__main__':
        main() 