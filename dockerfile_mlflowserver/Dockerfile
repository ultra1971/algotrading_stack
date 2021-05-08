FROM continuumio/miniconda3

COPY requirements.txt /tmp/

RUN pip install --requirement /tmp/requirements.txt && \
    apt update && \
    apt-get install curl -y

ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8
