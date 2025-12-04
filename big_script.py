import pandas as pd
import seaborn as sns 
from sklearn.metrics import classification_report, confusion_matrix, ConfusionMatrixDisplay
from sklearn.tree import DecisionTreeClassifier
from sklearn.model_selection import train_test_split
from sklearn.dummy import DummyClassifier
from sklearn.model_selection import train_test_split
from ucimlrepo import fetch_ucirepo
import pointblank as pb

# fetch dataset 
iris = fetch_ucirepo(id=53) 

iris = iris.data.original


#validation
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
iris = validation.get_sundered_data(type="pass")

#splitting and mapping
iris_train, iris_test = train_test_split(iris, test_size=0.2, random_state=522)
X_train, X_test = iris_train.drop(columns=['class']), iris_test.drop(columns=['class'])
y_train, y_test = iris_train[['class']], iris_test[['class']]

y_train['class']=y_train['class'].map({'Iris-setosa': 0,'Iris-versicolor':1,'Iris-virginica':2})
y_test['class']=y_test['class'].map({'Iris-setosa': 0,'Iris-versicolor':1,'Iris-virginica':2})

#Plots
plt = sns.pairplot(iris_train, hue='class')

plt_corr = sns.heatmap(iris_train.drop(columns =['class'], axis=1).corr(), annot=True)

histplot = sns.histplot(
    data=iris_train, 
    x='petal width', 
    hue='class', 
    bins=50, 
    alpha=0.5,
    multiple='layer'

).set_title('Distribution of Petal Width by Flower Species')

#Model building
tree = DecisionTreeClassifier(max_depth=3)
tree.fit(X_train, y_train)
test_score = tree.score(X_test, y_test)


#Metric plots
y_pred = tree.predict(X_test)
print(classification_report(y_test, y_pred))
cm = confusion_matrix(y_test, y_pred, labels=tree.classes_)
disp = ConfusionMatrixDisplay(confusion_matrix=cm, display_labels=tree.classes_)
disp.plot()