FROM apache/airflow:2.4.0-python3.8
#:apache/airflow:2.1.2-python3.8

USER root

RUN apt-get update && apt-get install -y \
	        python3 unzip \
	        python3-dev \
            libhdf5-serial-dev python3-tables python-tables-doc \
            bash vim font-manager xfonts-utils fontconfig\
	        g++ make wget git curl gcc gnupg2 \
    && rm -rf /var/lib/apt/lists/*

#RUN pip install numpy 

# TA-Lib
#RUN wget http://prdownloads.sourceforge.net/ta-lib/ta-lib-0.4.0-src.tar.gz && \
#  tar -xvzf ta-lib-0.4.0-src.tar.gz && \
#  cd ta-lib/ && \
#  ./configure --prefix=/usr && \
#  make && \
#  make install

#RUN rm -R ta-lib ta-lib-0.4.0-src.tar.gz

RUN curl -L https://downloads.sourceforge.net/project/ta-lib/ta-lib/0.4.0/ta-lib-0.4.0-src.tar.gz | tar xvz

#WORKDIR /ta-lib
# numpy needs to be installed before TA-Lib
RUN pip3 install 'numpy==1.22.4' \
  && cd ta-lib/ \
  && ./configure --prefix=/usr \
  && make \
  && make install \
  && pip3 install 'TA-Lib==0.4.24'

RUN cd .. && rm -rf ta-lib/
ENV NUMBA_CACHE_DIR=/tmp
#RUN mkdir -p /home/airflow/.cache/matplotlib
#RUN chmod 775 /home/airflow/.cache/matplotlib

#RUN mkdir -p /home/airflow/.config/fontconfig/conf.d/
#COPY 20-consolas.conf /home/airflow/.config/fontconfig/conf.d/20-consolas.conf

USER airflow

COPY requirements.txt /tmp/
RUN pip3 install --requirement /tmp/requirements.txt

#COPY /usr/share/fonts/truetype/ /usr/share/fonts/truetype/
RUN fc-cache -fv
RUN rm /home/airflow/.cache/matplotlib -rf

#RUN mkdir -p /usr/share/fonts/consolas
#COPY consolas /usr/share/fonts/
#COPY ./consolas/*.* /usr/share/fonts/consolas/
#RUN chmod 644 /usr/share/fonts/consolas/YaHei.Consolas.1.12.ttf
#RUN cd /usr/share/fonts/consolas
RUN mkfontscale && mkfontdir && fc-cache -fv

ENV PYTHONPATH "${PYTHONPATH}:/usr/local/airflow/dags"
ENV NUMBA_CACHE_DIR=/tmp

COPY locator.py /home/airflow/.local/lib/python3.8/site-packages/backtrader/plot/locator.py
COPY plot.py /home/airflow/.local/lib/python3.8/site-packages/backtrader/plot/plot.py
COPY yahoo.py /home/airflow/.local/lib/python3.8/site-packages/backtrader/feeds/yahoo.py



