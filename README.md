# Iris Flower Species Classifier  
**Authors:** Suryash Chakravarty, Hooman Esteki & Bright Arafat Bello  
A reproducible machine-learning workflow project for DSCI 522 (Data Science Workflows) in the UBC Master of Data Science program.

---

## About

The essence of this project is the investigation into the potential of a machine learning model to classify iris flowers into one of the three species, namely, *Setosa*, *Versicolor*, and *Virginica*, based on just four numerical measurements of the petals and sepals. The work being done here is a clear illustration of the reproducible workflow that adheres to the teachings of **DSCI 522 (Data Science Workflows)** course in UBC’s Master of Data Science program.

We performed the training and evaluation of a **Decision Tree Classifier** with processed training data and then judged the classifier's performance on a completely novel test set. The final model was able to determine the test samples with an accuracy of **86%**, which indicates that the model successfully distinguished the majority of iris samples based only on simple geometric measurements. The confusion matrix illustrates flawless recognition of *Setosa*, whereas a little mixing up happens between the other two species, *Versicolor* and *Virginica*, which is normal due to the fact that they share some overlapping biological traits.

Despite the fact that the model is very accurate in general, it still has some significant limitations. The Iris dataset is very small consisting only of 150 samples, and two species, namely, *Versicolor* and *Virginica*, not only have very similar feature distributions but are also, therefore, very difficult to separate. Moreover, only one model type (the decision tree) was studied during the analysis, thus there are still ways to obtain better performance through hyperparameter tuning, cross-validation, or utilizing more advanced classifiers like Random Forests or SVMs.

The dataset that was used for this project is the famous **Iris dataset** which was first introduced by Ronald Fisher (1936). Each of the three species in the dataset has 50 samples and the dataset has been used as a benchmark for the very first supervised learning concepts.  
The dataset was obtained from the **UCI Machine Learning Repository**:

Dataset link: https://archive.ics.uci.edu/dataset/

---

## Report

The complete project report (HTML and PDF) can be found in:

```
report/iris_report.html
report/iris_report.pdf
```

The source Quarto document is:

```
notebooks/iris_report.qmd
```

---

## Dependencies

This project uses a container-based workflow for full reproducibility.

- The Docker image is built from `quay.io/jupyter/minimal-notebook`  
- All additional dependencies (Python, Quarto, scikit-learn, seaborn, etc.) are installed via our custom **Dockerfile**
- For local (non-Docker) workflows, dependencies are managed using **conda-lock**

---

## Usage

There are two supported ways to reproduce the analysis.

---

## **Option 1 (Recommended): Run using Docker Compose**

### **Start**

Make sure Docker Desktop is running.

From the root of the repository, run:

```bash
make build
make up
```

Look for a URL starting with:

```
http://127.0.0.1:8888/lab?token=
```

Paste it into your browser to open JupyterLab inside the container.

### **Run the full analysis pipeline**

Inside JupyterLab’s terminal:

```bash
python scripts/01data_import.py --url="https://archive.ics.uci.edu/static/public/53/iris.zip" --write_to=data/raw

python scripts/02validation_splitting.py --raw_data=data/raw/iris.data --data_to=data --seed=522

python scripts/03eda_plots.py --processed_training_data=data/iris_train.csv --plot_to=figures

python scripts/04model.py --training_data=data --model_to=model --seed=522

python scripts/05metrics.py --test_data=data --model_from=model --metrics_to=metrics --plot_to=figures

quarto render notebooks/iris_report.qmd --to html
quarto render notebooks/iris_report.qmd --to pdf
```

### **Alternative (Run notebook)**  
Open:

```
notebooks/iris_summary.ipynb
```

and run all cells.

### **Stop the container**

```bash
make stop
docker compose rm
```

---

## **Option 2: Local Setup Using conda-lock**

### **Install conda-lock**

```bash
conda install -c conda-forge conda-lock -y
```

### **Create the environment**

```bash
conda-lock install --name 522-iris conda-lock.yml
conda activate 522-iris
```

### **Run the full workflow**

```bash
python scripts/01data_import.py --url="https://archive.ics.uci.edu/static/public/53/iris.zip" --write_to=data/raw

python scripts/02validation_splitting.py --raw_data=data/raw/iris.data --data_to=data --seed=522

python scripts/03eda_plots.py --processed_training_data=data/iris_train.csv --plot_to=figures

python scripts/04model.py --training_data=data --model_to=model --seed=522

python scripts/05metrics.py --test_data=data --model_from=model --metrics_to=metrics --plot_to=figures

quarto render notebooks/iris_report.qmd --to html
quarto render notebooks/iris_report.qmd --to pdf
```

### **Alternative:**  
Run:

```
notebooks/iris_summary.ipynb
```

---

## 🛠 Developer Notes

### Working inside the container using JupyterLab

```bash
make up
```

Open the Jupyter token URL printed in the terminal.

### Working inside the container using VS Code

From the project root:

```bash
docker compose run --rm terminal bash
```

To exit:

```bash
exit
```

---

## Clean Up

To stop and remove all running analysis resources:

```bash
make stop
docker compose rm
```

---

## References

- Fisher, R. A. (1936). *Iris*. UCI Machine Learning Repository. https://doi.org/10.24432/C56C76  
- Pedregosa et al. (2011). *Scikit-learn: Machine Learning in Python*. JMLR.  
- Waskom, M. (2021). *Seaborn: Statistical Data Visualization*.  
- UBC MDS Program (2025). *DSCI 522: Data Science Workflows — Milestone Instructions*.  
- UBC MDS Program (2025). *DSCI 571: Supervised Learning I — Course Materials*.

---

## License

All analysis code is licensed under the **MIT License** (see `LICENSE` file).  
The report and documentation follow the usage guidelines of the UBC MDS program.

