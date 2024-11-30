# Use a TensorFlow image with a newer Python version (e.g., Python 3.9)
FROM tensorflow/tensorflow:2.13.0-jupyter

# Set environment variables to reduce interactive prompts and cache pip installations
ENV DEBIAN_FRONTEND=noninteractive \
    PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1 \
    PYTHONDONTWRITEBYTECODE=1

# Update and install system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    python3-dev \
    git \
    cmake \
    build-essential \
    libgl1-mesa-glx \
    libglib2.0-0 \
    swig \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Upgrade pip and uninstall conflicting packages
RUN pip install --no-cache-dir --upgrade pip \
    && pip uninstall -y enum34

# Install Python libraries
RUN pip install --no-cache-dir \
    numpy \
    pandas \
    matplotlib \
    seaborn \
    scikit-learn \
    xgboost \
    "ray[default]" \
    "gym[all]" \
    tensorflow-probability \
    "stable-baselines3[extra]" \
    yfinance \
    streamlit \
    aiohttp \
    alpaca-trade-api \
    python-dotenv \
    transformers \
    nest-asyncio \
    sqlalchemy \
    twilio \
    opencv-python-headless

# Set working directory
WORKDIR /app

# Copy your bot code into the container
COPY . .

# Expose Streamlit dashboard port
EXPOSE 8501

# Set entrypoint to execute the notebook directly using nbconvert
RUN pip install nbconvert
CMD ["jupyter", "nbconvert", "--to", "script", "main.ipynb", "--execute"]