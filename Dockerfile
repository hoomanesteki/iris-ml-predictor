# Base image (good choice)
FROM condaforge/miniforge3:latest

# Ensure bash is default shell for conda activation
SHELL ["/bin/bash", "-c"]

# Set working directory
WORKDIR /home/jovyan/work

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

# patch fix for the quarto folder
RUN mkdir -p /opt/conda/envs/522-iris/bin/tools/x86_64 && \
    ln -sf /opt/conda/envs/522-iris/bin/deno /opt/conda/envs/522-iris/bin/tools/x86_64/deno

# Expose Jupyter port
EXPOSE 8888

# Default command: JupyterLab
CMD ["jupyter", "lab", "--ip=0.0.0.0", "--no-browser", "--allow-root"]
