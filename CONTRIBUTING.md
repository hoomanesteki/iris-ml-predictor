# Contributing to Iris ML Classifier

We welcome any input, feedback, or contributions to improve this project. If you would like to contribute, please follow these guidelines:

## Fixing Typos

Small typos or grammatical errors in documentation may be edited directly using the Github web interface, so long as the changes are made in the source file.

## Pull Requests (PR)

1. Start by Forking the repository to your own GitHub account, and then clone it to your local machine. For more details on forking, visit the github documentation: https://help.github.com/en/articles/fork-a-repo
    To clone the repository, use the following command:
    ```
    git clone https://github.com/YOUR-USERNAME/iris-ml-predictor.git
    ```
2. Initialise a new virtual environment based on your preferred tool, using our environment.yml file:
    ```
    conda env create -f environment.yml
    ```

3. Create a new branch to work on your changes:
    ```
    git branch <branch name>
    git switch <branch name>
    ```
    Or in one step:

    ```
    git switch -c <branch name>
    ```

4. Make your changes, commit and push to your forked repository. We recommend that you create a new Git Branch for every Pull Request (PR).
5. Open a Pull Request (PR) to the main repository for review. Please provide a clear description of the changes you have made and the purpose of the PR.
6. Once your PR is reviewed and approved, it will be merged into the main repository and the branch, deleted.

## Code of Conduct

Please not that this project is released with a Contributor Code of Conduct, found at https://github.com/hoomanesteki/iris-ml-predictor/blob/main/CODE_OF_CONDUCT.md.

By participating in this project you agree to abide by these terms.

## Attribution

These contributing guidelines were adapted from the dplyr contributing guidelines, found here -->https://github.com/tidyverse/dplyr/blob/main/.github/CONTRIBUTING.md.

and the breast-cancer-predictor repository, found here --> https://github.com/ttimbers/breast-cancer-predictor/blob/0.0.1/CONTRIBUTING.md