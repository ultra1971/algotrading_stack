FROM apache/airflow:3.1.5-python3.11

ARG TALIB_URL=https://github.com/ta-lib/ta-lib/releases/download/v0.6.4/ta-lib_0.6.4_amd64.deb
ARG TALIB_SHA256=73b46ce1c8dd879950088ed29a32807e7bd00528624392abffa9b2e8a7b6f097

# Single stage on purpose: Airflow lives in a virtualenv under /home/airflow/.local, and a
# multi-stage "COPY --from=build /home/airflow/.local" merges with (instead of replacing) the
# base image's copy, leaving stale package metadata from the base behind.
USER root
RUN apt-get update && apt-get install -y \
            build-essential \
            python3-dev \
            libldap2-dev \
            libsasl2-dev \
            libssl-dev \
            libhdf5-serial-dev \
            bash vim font-manager xfonts-utils fontconfig \
            g++ make wget git curl gcc gnupg2 unzip \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN curl -fsSL "${TALIB_URL}" -o /tmp/ta-lib.deb \
    && echo "${TALIB_SHA256}  /tmp/ta-lib.deb" | sha256sum -c - \
    && dpkg -i /tmp/ta-lib.deb \
    && rm /tmp/ta-lib.deb

ENV NUMBA_CACHE_DIR=/tmp

USER airflow

# constraints.txt pins every package to the versions of the last image known to work.
COPY requirements.txt constraints.txt /tmp/
RUN pip install --no-cache-dir --upgrade pip \
    && pip install --no-cache-dir -c /tmp/constraints.txt apache-airflow-providers-fab \
    && pip install --no-cache-dir -c /tmp/constraints.txt -r /tmp/requirements.txt

# Patch backtrader's plotter wherever pip installed it (the old path was python3.9-only).
COPY plot.py /tmp/plot.py
RUN cp /tmp/plot.py "$(python -c 'import os, backtrader; print(os.path.dirname(backtrader.__file__))')/plot/plot.py"
