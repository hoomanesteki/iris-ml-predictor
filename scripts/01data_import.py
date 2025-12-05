import pandas as pd
from ucimlrepo import fetch_ucirepo
import os

# fetch dataset 
iris = fetch_ucirepo(id=53) 

iris = iris.data.original

directory = "data"

def create_dir_if_not_exists(directory):
        os.makedirs(directory, exist_ok=True)

create_dir_if_not_exists(directory)

iris.to_csv('data/iris.csv',index=False)