FROM apache/airflow:2.10.5-python3.11

USER root
RUN apt-get update && apt-get install -y \
	        python3 unzip \
	        python3-dev \
            libhdf5-serial-dev python3-tables python-tables-doc \
            bash vim font-manager xfonts-utils fontconfig\
	        g++ make wget git curl gcc gnupg2 \
    && rm -rf /var/lib/apt/lists/*

RUN curl -L https://github.com/ta-lib/ta-lib/releases/download/v0.6.4/ta-lib_0.6.4_amd64.deb -o ta-lib_0.6.4_amd64.deb
RUN dpkg -i ta-lib_0.6.4_amd64.deb

#RUN pip3 install numpy \
#  && pip3 install TA-Lib

ENV NUMBA_CACHE_DIR=/tmp

USER airflow

COPY requirements.txt /tmp/
RUN pip3 install --requirement /tmp/requirements.txt

COPY plot.py /home/airflow/.local/lib/python3.9/site-packages/backtrader/plot/plot.py

ENV PYTHONPATH "${PYTHONPATH}:/usr/local/airflow/dags"
ENV NUMBA_CACHE_DIR=/tmp
