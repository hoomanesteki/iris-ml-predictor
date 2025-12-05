import pandas as pd
from sklearn.model_selection import train_test_split

iris = pd.read_csv("data/iris_validated.csv")
iris_train, iris_test = train_test_split(iris, test_size=0.2, random_state=522)
X_train, X_test = iris_train.drop(columns=['class']), iris_test.drop(columns=['class'])
y_train, y_test = iris_train[['class']].copy(), iris_test[['class']].copy()

y_train['class']=y_train['class'].map({'Iris-setosa': 0,'Iris-versicolor':1,'Iris-virginica':2})
y_test['class']=y_test['class'].map({'Iris-setosa': 0,'Iris-versicolor':1,'Iris-virginica':2})

iris_train.to_csv("data/iris_train.csv",index=False)
X_train.to_csv("data/X_train.csv",index=False)
X_test.to_csv("data/X_test.csv",index=False)
y_train.to_csv("data/y_train.csv",index=False)
y_test.to_csv("data/y_test.csv",index=False)