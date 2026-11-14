ARG AIRFLOW_IMAGE=apache/airflow:3.1.5-python3.11
ARG TALIB_URL=https://github.com/ta-lib/ta-lib/releases/download/v0.6.4/ta-lib_0.6.4_amd64.deb
ARG TALIB_SHA256=73b46ce1c8dd879950088ed29a32807e7bd00528624392abffa9b2e8a7b6f097

# ---------------------------------------------------------------------------
# Build stage: compilers and headers only live here.
# ---------------------------------------------------------------------------
FROM ${AIRFLOW_IMAGE} AS build
ARG TALIB_URL
ARG TALIB_SHA256

USER root
RUN apt-get update && apt-get install -y --no-install-recommends \
            build-essential \
            python3-dev \
            libldap2-dev \
            libsasl2-dev \
            libssl-dev \
            libhdf5-serial-dev \
            g++ make gcc git curl \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN curl -fsSL "${TALIB_URL}" -o /tmp/ta-lib.deb \
    && echo "${TALIB_SHA256}  /tmp/ta-lib.deb" | sha256sum -c - \
    && dpkg -i /tmp/ta-lib.deb

USER airflow
RUN pip install --no-cache-dir --upgrade pip \
    && pip install --no-cache-dir apache-airflow-providers-fab

COPY requirements.txt /tmp/
RUN pip install --no-cache-dir -r /tmp/requirements.txt

# Patch backtrader's plotter wherever pip installed it (the old path was python3.9-only).
COPY plot.py /tmp/plot.py
RUN cp /tmp/plot.py "$(python -c 'import os, backtrader; print(os.path.dirname(backtrader.__file__))')/plot/plot.py"

# ---------------------------------------------------------------------------
# Runtime stage: same base image + runtime libraries + the user site-packages.
# ---------------------------------------------------------------------------
FROM ${AIRFLOW_IMAGE}
ARG TALIB_URL
ARG TALIB_SHA256

USER root
RUN apt-get update && apt-get install -y --no-install-recommends \
            libhdf5-serial-dev \
            bash vim font-manager xfonts-utils fontconfig \
            wget git curl gnupg2 unzip \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# TA-Lib's shared library is needed at run time by the Python wrapper.
RUN curl -fsSL "${TALIB_URL}" -o /tmp/ta-lib.deb \
    && echo "${TALIB_SHA256}  /tmp/ta-lib.deb" | sha256sum -c - \
    && dpkg -i /tmp/ta-lib.deb \
    && rm /tmp/ta-lib.deb

ENV NUMBA_CACHE_DIR=/tmp

USER airflow
COPY --from=build --chown=airflow:0 /home/airflow/.local /home/airflow/.local
