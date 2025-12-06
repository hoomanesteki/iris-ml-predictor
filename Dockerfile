# Base image (good choice)
FROM condaforge/miniforge3:latest

# Ensure bash is default shell for conda activation
SHELL ["/bin/bash", "-c"]

# Set working directory
WORKDIR /home/jovyan/work

# install curl and quarto standalone
RUN apt-get update && \
    apt-get install -y curl ca-certificates && \
    curl -L -o quarto.deb https://quarto.org/download/latest/quarto-linux-amd64.deb && \
    apt-get install -y ./quarto.deb && \
    rm quarto.deb

# Copy repository contents (includes conda-lock.yml)
COPY conda-lock.yml .

# Install conda-lock + mamba
RUN mamba install -y conda-lock

# Create environment from lockfile (Docker will pick linux-64)
RUN conda-lock install --name 522-iris conda-lock.yml

# Activate environment by default
ENV CONDA_DEFAULT_ENV=522-iris
ENV PATH="/opt/conda/envs/522-iris/bin:${PATH}"

# Install Jupyter kernel
RUN python -m ipykernel install --user --name=522-iris --display-name="522-iris"

# Expose Jupyter port
EXPOSE 8888

# Default command: JupyterLab
CMD ["jupyter", "lab", "--ip=0.0.0.0", "--no-browser", "--allow-root"]
