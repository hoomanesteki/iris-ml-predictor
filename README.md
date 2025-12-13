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
Once the pipeline is done, the processed HTML report will be found [here](https://hoomanesteki.github.io/iris-ml-predictor/reports/iris_report.html).

The processed pdf will be found at: `reports/iris_report.pdf`

The original Quarto document that was used to create the report is: `reports/iris_report.qmd`

---

## Dependencies

Two reproducible execution environments are supported by this project.

Docker is the tool used for the containerized execution:
- The image is created from `quay.io/jupyter/minimal-notebook`
- A custom Dockerfile is used to install all required dependencies and managed using Docker Compose

In the case of local (non-Docker) execution, dependencies are managed using conda-lock:
- Requirements are specified in `environment.yml` and locked in `conda-lock.yml`

Regardless of the approach, the analysis is guaranteed to be reproducible across all machines.

---

## Usage

There are two supported ways to reproduce the analysis.



#### Option 1 (Recommended): Run using Docker Compose

1. First step will be to get the repository cloned and change into the project folder:
```bash
git clone https://github.com/hoomanesteki/iris-ml-predictor.git
cd iris-ml-predictor
```
2. Check if Docker Desktop is active on your computer.

3. Make the Docker image and running the containerized environment from the repository root:
```bash
make build
make up
```
4. Once the container is up, there will be a URL printed in the terminal with:
`http://127.0.0.1:8888/lab?token=`

Using your browser, copy this URL and paste it to access JupyterLab within the Docker container.
 
5. Use the Makefile to run the total analysis pipeline.
Through a terminal in JupyterLab (or from the project directory), execute:
```bash
make all
```

All analysis steps in the right order will be executed and the final HTML report will be published to [https://hoomanesteki.github.io/iris-ml-predictor/reports/iris_report.html](https://hoomanesteki.github.io/iris-ml-predictor/reports/iris_report.html)

6. To run the entire pipeline from scratch (including data download, model fitting, report generation), run:
```bash
make scratch
```

7. (Optional) If you want to get rid of all the generated files and bring back the project to a clean state, then run:
```bash
make clean
```

8. Finally, to stop and remove Docker containers, do the following:
    In the terminal hit control + c, then run the following in the terminal;
```bash
make stop
docker compose rm
```

---

#### Option 2: Local Setup Using conda-lock

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

Upon completion of the pipeline, the finalized HTML report will be found at: `reports/iris_report.html`.

The processed pdf will be found at: `reports/iris_report.pdf`

5. (Optional) Clean up all the created files and bring back the project to its original state by running:
```bash
make clean
```
---

## Developer Notes

### Working inside the container (JupyterLab)

In order to initiate the containerized environment and launch JupyterLab, execute:
```bash
make up
```
Take the Jupyter token URL that will be displayed in the terminal and paste it into your browser.

### Working inside the container (command line only)

In case you want to work with the terminal inside the container straight away (for instance, using VS Code or CLI tools), execute:
```bash
docker compose run --rm terminal bash
```
To leave the container shell, type:
```bash
exit
```
---

## Testing

To ensure the analysis pipeline's important parts, some basic unit tests are included.

The tests cover:
- Logic of data import and validation
- The reproducibility and correctness of the split between the training and test datasets

The tests are written in `pytest` and can be executed from the root of the project via:
```bash
pytest
```

---

## Clean Up

In order to halt and eliminate all the Docker containers that are already running and were used for the analysis, execute the following commands:
```bash
make stop
docker compose rm
```
To wipe out all the files produced during the process and to reset the project completely, you can use the command:
```bash
make clean
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

### Project Acknowledgment

This project is a demonstration for educational purposes, and the structure and workflow was adapted from the “Breast Cancer Predictor” project by Tiffany Timbers, Melissa Lee, Joel Ostblom & Weilin Han.

