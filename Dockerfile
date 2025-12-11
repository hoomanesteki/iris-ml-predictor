# Base image (good choice)
FROM condaforge/miniforge3:latest

# Ensure bash is default shell for conda activation
SHELL ["/bin/bash", "-c"]

# Set working directory
WORKDIR /home/jovyan/work

RUN apt-get update && apt-get install -y \
    curl \
    apt-get clean \
    && rm -rf /var/lib/apt/lists/*

ARG TARGETARCH
ARG QUARTO_VERSION=1.8.26
RUN if [ "$TARGETARCH" = "amd64" ]; then \
    QUARTO_ARCH="amd64"; \
    elif [ "$TARGETARCH" = "arm64" ]; then \
    QUARTO_ARCH="arm64"; \
    else \
    echo "Unsupported architecture: $TARGETARCH" && exit 1; \
    fi && \
    curl -LO https://github.com/quarto-dev/quarto-cli/releases/download/v${QUARTO_VERSION}/quarto-${QUARTO_VERSION}-linux-${QUARTO_ARCH}.tar.gz && \
    mkdir -p /opt/quarto && \
    tar -xzf quarto-${QUARTO_VERSION}-linux-${QUARTO_ARCH}.tar.gz -C /opt/quarto --strip-components=1 && \
    rm quarto-${QUARTO_VERSION}-linux-${QUARTO_ARCH}.tar.gz && \
    ln -s /opt/quarto/bin/quarto /usr/local/bin/quarto && \
    # Clean up quarto installation files we don't need
    rm -rf /opt/quarto/share/jupyter

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
