import pandas as pd
import pointblank as pb


iris = pd.read_csv("data/iris.csv")
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
iris_validated.to_csv("data/iris_validated.csv",index=False)