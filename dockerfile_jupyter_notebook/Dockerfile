FROM jupyter/datascience-notebook:python-3.10.11

USER root

RUN apt-get update && apt-get install -y \
	        python3 \
	        python3-dev \
            bash vim \
	        g++ make wget git curl gcc gnupg2 \
    && rm -rf /var/lib/apt/lists/

#RUN pip install numpy 
# TA-Lib
#RUN wget http://prdownloads.sourceforge.net/ta-lib/ta-lib-0.4.0-src.tar.gz && \
#  tar -xvzf ta-lib-0.4.0-src.tar.gz && \
#  cd ta-lib/ && \
#  ./configure --prefix=/usr && \
#  make && \
#  make install
#RUN rm -R ta-lib ta-lib-0.4.0-src.tar.gz

RUN curl -L https://github.com/ta-lib/ta-lib/releases/download/v0.6.4/ta-lib_0.6.4_amd64.deb
RUN dpkg -i ta-lib_0.6.4_amd64.deb

RUN pip3 install numpy \
  && pip3 install TA-Lib

COPY requirements.txt /tmp/
RUN pip install --requirement /tmp/requirements.txt && \
    fix-permissions $CONDA_DIR && \
    fix-permissions /home/$NB_USER && \
    apt update && \
    apt-get install curl -y

ENV PYTHONPATH "${PYTHONPATH}:/home/jovyan/work"

RUN python -m pip install --upgrade --no-deps --force-reinstall notebook

RUN python -m pip install jupyterthemes
RUN python -m pip install --upgrade jupyterthemes
RUN python -m pip install jupyter_contrib_nbextensions
# RUN jupyter contrib nbextension install --user
# enable the Nbextensions
#RUN jupyter nbextension enable contrib_nbextensions_help_item/main
#RUN jupyter nbextension enable autosavetime/main
#RUN jupyter nbextension enable codefolding/main
#RUN jupyter nbextension enable code_font_size/code_font_size
#RUN jupyter nbextension enable code_prettify/code_prettify
#RUN jupyter nbextension enable collapsible_headings/main
#RUN jupyter nbextension enable comment-uncomment/main
#RUN jupyter nbextension enable equation-numbering/main
#RUN jupyter nbextension enable execute_time/ExecuteTime 
#RUN jupyter nbextension enable gist_it/main 
#RUN jupyter nbextension enable hide_input/main 
#RUN jupyter nbextension enable spellchecker/main
#RUN jupyter nbextension enable toc2/main
#RUN jupyter nbextension enable toggle_all_line_numbers/main

CMD ["jupyter", "notebook", "--no-browser","--NotebookApp.token=''","--NotebookApp.password=''", "--allow-root"]

RUN sudo groupadd -g 1020 airflow
RUN sudo useradd -s /bin/false -u 1010 -g 1020 airflow

