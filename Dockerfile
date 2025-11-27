FROM quay.io/jupyter/minimal-notebook:2024-11-19

# Set working directory
WORKDIR /home/jovyan/work

# Copy lock files
COPY conda-lock.linux-64.yml /tmp/conda-lock.yml

# Install conda-lock
RUN mamba install -y conda-lock

# Create environment using conda-lock
RUN conda-lock install --name iris-env /tmp/conda-lock.yml

# Activate environment and install pip dependencies (PyTorch, LightGBM)
RUN /opt/conda/envs/iris-env/bin/pip install \
    torch==2.3.0 \
    torchvision==0.18.0 \
    torchaudio==2.3.0 \
    lightgbm==4.3.0

# Set iris-env as default
ENV CONDA_DEFAULT_ENV=iris-env
ENV PATH="/opt/conda/envs/iris-env/bin:${PATH}"

# Jupyter kernel
RUN python -m ipykernel install --user --name=iris-env --display-name "Iris ML Env"

# Copy project files
COPY . .
