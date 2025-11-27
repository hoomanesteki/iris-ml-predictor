# FROM quay.io/jupyter/minimal-notebook:2024-11-19
FROM condaforge/miniforge3:latest

# Set working directory
WORKDIR /home/jovyan/work

# Copy lock file
COPY conda-lock.yml /tmp/conda-lock.yml

# Install conda-lock
RUN mamba install -y conda-lock

# Create environment using conda-lock
RUN conda-lock install --name iris-env /tmp/conda-lock.yml

# Set iris-env as default
ENV CONDA_DEFAULT_ENV=iris-env
ENV PATH="/opt/conda/envs/iris-env/bin:${PATH}"

# Jupyter kernel
RUN python -m ipykernel install --user --name=iris-env --display-name "Iris ML Env"

# Copy project files.
COPY . .
