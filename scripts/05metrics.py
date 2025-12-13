import os
import pickle
import pandas as pd
import seaborn as sns
from sklearn.metrics import accuracy_score, f1_score, precision_score, recall_score, classification_report, confusion_matrix, ConfusionMatrixDisplay
import click

def create_dir_if_not_exists(directory):
        os.makedirs(directory, exist_ok=True)

@click.command()
@click.option('--test_data', type=str, help="Path to test data")
@click.option('--model_from', type=str, help="Path to model")
@click.option('--metrics_to', type=str, help="Path to directory where the metrics will be written to")
@click.option('--plot_to', type=str, help="Path to directory where the figures will be written to")

def main(test_data, model_from, metrics_to, plot_to):
    '''
    Create all and export all metrics from the decision tree classifier model on the iris dataset
    
    :param test_data: path to directory where test data is saved
    :param model_from: path to directory where model.pkl file is saved
    :param metrics_to: path to directory where all reports should be saved
    :param plot_to: path to directory where all plots should be saved
    '''

    #check if metrics directory exists, if not create it
    create_dir_if_not_exists(metrics_to)

    #load model
    model_path = os.path.join(model_from, "tree_model.pkl")
    dummy_path = os.path.join(model_from, "dummy_model.pkl")
    with open(model_path, "rb") as f:
        model = pickle.load(f)
    
    with open(dummy_path, "rb") as f:
        dummy = pickle.load(f)

    #load test data
    X_test = pd.read_csv(os.path.join(test_data, "X_test.csv"))
    y_test = pd.read_csv(os.path.join(test_data, "y_test.csv"))

    X_train = pd.read_csv(os.path.join(test_data, "X_train.csv"))
    y_train = pd.read_csv(os.path.join(test_data, "y_train.csv"))


    #Dummy metrics on train data
    labels = ['setosa','versicolor','virginica']
    dummy_pred = dummy.predict(X_train)

    dummy_report = classification_report(y_train, dummy_pred, output_dict=True, zero_division=0) 
    dummy_report_df = pd.DataFrame(dummy_report).transpose()
    dummy_report_df.to_csv(os.path.join(metrics_to, "dummy_report_df.csv"),index=False)

    cm_dummy = ConfusionMatrixDisplay.from_predictions(y_train, dummy_pred, display_labels=labels)
    cm_dummy.figure_.savefig(os.path.join(plot_to, "dummy_confusion_matrix.png"), bbox_inches="tight")
    

    #make predictions on test data
    y_pred = model.predict(X_test)

    #calculate metrics
    acc = accuracy_score(y_test, y_pred)
    prec = precision_score(y_test, y_pred, average="weighted")
    rec  = recall_score(y_test, y_pred, average="weighted")
    f1   = f1_score(y_test, y_pred, average="weighted")

    #create report and save to folder
    report = classification_report(y_test, y_pred, output_dict=True) 
    report_df = pd.DataFrame(report).transpose()
    report_df.to_csv(os.path.join(metrics_to, "report_df.csv"),index=False)

    #create and save metrics
    metrics_summary = {
        "accuracy": acc,
        "precision_weighted": prec,
        "recall_weighted": rec,
        "f1_weighted": f1
    }
    metrics_summary = pd.DataFrame([metrics_summary])
    metrics_summary.to_csv(os.path.join(metrics_to, "metrics_summary.csv"),index=False)

    #create and save confusion matrix
    cm = confusion_matrix(y_test, y_pred)
    labels = ['setosa','versicolor','virginica']
    cm_df = pd.DataFrame(cm, index=labels, columns=labels)
    cm_df.to_csv(os.path.join(metrics_to, "confusion_matrix.csv"),index=False)

    #save confusion matrix as figure and export to directory
    cm = ConfusionMatrixDisplay.from_predictions(y_test, y_pred, display_labels=labels)
    cm.figure_.savefig(os.path.join(plot_to, "confusion_matrix.png"), bbox_inches="tight")

if __name__ == '__main__':
     main()