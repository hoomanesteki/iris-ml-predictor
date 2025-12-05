import pandas as pd 
from sklearn.tree import DecisionTreeClassifier
import pickle
import os

directory = "model"
def create_dir_if_not_exists(directory):
        os.makedirs(directory, exist_ok=True)

create_dir_if_not_exists(directory)

X_train = pd.read_csv("data/X_train.csv")
y_train = pd.read_csv("data/y_train.csv")


tree = DecisionTreeClassifier(max_depth=3)
tree.fit(X_train, y_train)

with open("model/tree_model.pkl", "wb") as f:
    pickle.dump(tree, f)