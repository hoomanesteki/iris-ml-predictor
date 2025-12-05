import os
import pickle
import pandas as pd
import seaborn as sns
from sklearn.metrics import accuracy_score, f1_score, precision_score, recall_score, classification_report, confusion_matrix, ConfusionMatrixDisplay

directory = "metrics"
def create_dir_if_not_exists(directory):
        os.makedirs(directory, exist_ok=True)

create_dir_if_not_exists(directory)

model_path = "model/tree_model.pkl"
with open(model_path, "rb") as f:
    model = pickle.load(f)

X_test = pd.read_csv("data/X_test.csv")
y_test = pd.read_csv("data/y_test.csv").iloc[:, 0]

y_pred = model.predict(X_test)


acc = accuracy_score(y_test, y_pred)
prec = precision_score(y_test, y_pred, average="weighted")
rec  = recall_score(y_test, y_pred, average="weighted")
f1   = f1_score(y_test, y_pred, average="weighted")


report = classification_report(y_test, y_pred, output_dict=True) 
report_df = pd.DataFrame(report).transpose()
report_df.to_csv("metrics/report_df.csv",index=False)


metrics_summary = {
    "accuracy": acc,
    "precision_weighted": prec,
    "recall_weighted": rec,
    "f1_weighted": f1
}

metrics_summary = pd.DataFrame([metrics_summary])
metrics_summary.to_csv("metrics/metrics_summary.csv",index=False)



cm = confusion_matrix(y_test, y_pred)
labels = ['setosa','versicolor','virginica']
cm_df = pd.DataFrame(cm, index=labels, columns=labels)
cm_df.to_csv("metrics/confusion_matrix.csv",index=False)



cm = ConfusionMatrixDisplay.from_predictions(y_test, y_pred, display_labels=labels)
cm.figure_.savefig("figures/confusion_matrix.png", bbox_inches="tight")

