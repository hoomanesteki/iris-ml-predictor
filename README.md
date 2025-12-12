# Iris Flower Species Classifier  
**Authors:** Suryash Chakravarty, Hooman Esteki & Bright Arafat Bello  
A reproducible machine-learning workflow project for DSCI 522 (Data Science Workflows) in the UBC Master of Data Science program.

---

## About

The essence of this project is the investigation into the potential of a machine learning model to classify iris flowers into one of the three species, namely, *Setosa*, *Versicolor*, and *Virginica*, based on just four numerical measurements of the petals and sepals. The work being done here is a clear illustration of the reproducible workflow that adheres to the teachings of **DSCI 522 (Data Science Workflows)** course in UBC’s Master of Data Science program.

The dataset that was used for this project is the famous **Iris dataset** which was first introduced by Ronald Fisher (1936). Each of the three species in the dataset has 50 samples and the dataset has been used as a benchmark for the very first supervised learning concepts.  
The dataset was obtained from the **UCI Machine Learning Repository**:

Dataset link: https://archive.ics.uci.edu/dataset/

---

## Report

The report of the project is produced automatically by the analysis pipeline and does not get saved in the repository.

To generate the report again, execute the entire workflow with:

```
make all

```
Once the pipeline is done, the processed HTML report will be found at:

reports/iris_report.html

The original Quarto document that was used to create the report is:

reports/iris_report.qmd

---

## Dependencies

Two reproducible execution environments are supported by this project.

Docker is the tool used for the containerized execution:
- The image is created from `quay.io/jupyter/minimal-notebook`
- A custom Dockerfile is used to install all required dependencies and managed using Docker Compose

In the case of local (non-Docker) execution, dependencies are managed using conda-lock:
- Requirements are specified in environment.yml and locked in conda-lock.yml

Regardless of the approach, the analysis is guaranteed to be reproducible across all machines.

---

## Usage

There are two supported ways to reproduce the analysis.

---

## **Option 1 (Recommended): Run using Docker Compose**

### **Start**

Clone this repository locally to your machine.

```bash
git clone https://github.com/hoomanesteki/iris-ml-predictor.git
cd iris-ml-predictor
```

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


### Run the full analysis pipeline

The entire analysis pipeline is managed through the Makefile.

Run from the terminal in JupyterLab (or from the project root if in local environment):

```bash
make all
```

This command runs all analysis steps in the right order and prepares the final report located in:

`reports/iris_report.html`

To delete all files created and return the project to a clean state, type:

```bash
make clean

```

### Stop the container

To stop and remove the running Docker containers, run:

```bash
make stop
docker compose rm
```

---

## Option 2: Local Setup Using conda-lock

1. First, you need to clone the repository and then switch to the project directory as follows:
```bash
git clone https://github.com/hoomanesteki/iris-ml-predictor.git
cd iris-ml-predictor
```
2. If you haven't done so already, install the conda-lock package:
```bash
conda install -c conda-forge conda-lock -y
```
3. Generate and enable the reproducible environment:
```bash
conda-lock install --name 522-iris conda-lock.yml
conda activate 522-iris 
```
4. Using the Makefile, the entire analysis pipeline will be executed:
```bash
make all
```

Upon completion of the pipeline, the finalized HTML report will be found in:
`reports/iris_report.html`

5. (Optional) Clean up all the created files and bring back the project to its original state by running:
```bash
make clean
```
---

## Developer Notes

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

