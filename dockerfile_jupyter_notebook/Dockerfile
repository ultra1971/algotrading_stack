FROM jupyter/datascience-notebook:x86_64-python-3.11.6

USER root

RUN apt-get update && apt-get install -y --no-install-recommends \
        python3-dev \
        bash vim \
        g++ make wget git curl gcc gnupg2 \
    && rm -rf /var/lib/apt/lists/*

RUN curl -L https://github.com/ta-lib/ta-lib/releases/download/v0.6.4/ta-lib_0.6.4_amd64.deb \
        -o /tmp/ta-lib.deb \
    && dpkg -i /tmp/ta-lib.deb \
    && rm /tmp/ta-lib.deb

RUN groupadd -g 1020 airflow \
    && useradd -s /bin/false -u 1010 -g 1020 airflow

COPY requirements.txt /tmp/requirements.txt

RUN pip install --no-cache-dir \
        numpy \
        TA-Lib \
    && pip install --no-cache-dir -r /tmp/requirements.txt \
    && fix-permissions $CONDA_DIR \
    && fix-permissions /home/$NB_USER

RUN pip install --no-cache-dir \
        jupyterlab>=4.0 \
        jupyterlab-git \
        jupyterlab-lsp \
        python-lsp-server[all] \
        jupyterlab_code_formatter \
        black \
        isort \
        ipywidgets \
        jupyter-resource-usage \
        nbformat \
        nbconvert

ENV PYTHONPATH="${PYTHONPATH}:/home/jovyan/work"

USER $NB_UID
CMD ["jupyter", "lab", \
     "--no-browser", \
     "--NotebookApp.token=''", \
     "--NotebookApp.password=''"]
