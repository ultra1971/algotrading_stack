FROM apache/airflow:2.9.3-python3.10

USER root
RUN apt-get update && apt-get install -y \
	        python3 unzip \
	        python3-dev \
            libhdf5-serial-dev python3-tables python-tables-doc \
            bash vim font-manager xfonts-utils fontconfig\
	        g++ make wget git curl gcc gnupg2 \
    && rm -rf /var/lib/apt/lists/*


RUN curl -L https://downloads.sourceforge.net/project/ta-lib/ta-lib/0.4.0/ta-lib-0.4.0-src.tar.gz | tar xvz

RUN pip3 install 'numpy==1.23.5' \
  && cd ta-lib/ \
  && ./configure --prefix=/usr \
  && make \
  && make install \
  && pip3 install 'TA-Lib==0.4.32'
RUN cd .. && rm -rf ta-lib/
ENV NUMBA_CACHE_DIR=/tmp

USER airflow

COPY requirements.txt /tmp/
RUN pip3 install --requirement /tmp/requirements.txt

COPY plot.py /home/airflow/.local/lib/python3.9/site-packages/backtrader/plot/plot.py

ENV PYTHONPATH "${PYTHONPATH}:/usr/local/airflow/dags"
ENV NUMBA_CACHE_DIR=/tmp
