# Base image (good choice)
FROM condaforge/miniforge3:latest

# Ensure bash is default shell for conda activation
SHELL ["/bin/bash", "-c"]

# Set working directory
WORKDIR /home/jovyan/work

# Copy repository contents (includes conda-lock.yml)
COPY . .

# Install conda-lock + mamba
RUN mamba install -y mamba conda-lock

# Create environment from lockfile (Docker will pick linux-64)
RUN conda-lock install --name iris-env conda-lock.yml

# Activate environment by default
ENV CONDA_DEFAULT_ENV=iris-env
ENV PATH="/opt/conda/envs/iris-env/bin:${PATH}"

# Install Jupyter kernel
RUN python -m ipykernel install --user --name=iris-env --display-name="Iris ML Env"

# Expose Jupyter port
EXPOSE 8888

# Default command: JupyterLab
CMD ["jupyter", "lab", "--ip=0.0.0.0", "--no-browser", "--allow-root"]
