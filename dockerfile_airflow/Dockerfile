FROM apache/airflow:master-python3.8

USER root

RUN apt-get update && apt-get install -y \
	        python3 \
	        python3-dev \
            bash vim \
	        g++ make wget git \
    && rm -rf /var/lib/apt/lists/*

USER airflow

COPY requirements.txt /tmp/
RUN pip3 install --requirement /tmp/requirements.txt

ENV PYTHONPATH "${PYTHONPATH}:/usr/local/airflow/dags"

COPY locator.py /home/airflow/.local/lib/python3.8/site-packages/backtrader/plot/locator.py


