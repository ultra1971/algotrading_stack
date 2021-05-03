FROM jupyter/datascience-notebook

USER root

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
RUN jupyter contrib nbextension install --user
# enable the Nbextensions
RUN jupyter nbextension enable contrib_nbextensions_help_item/main
RUN jupyter nbextension enable autosavetime/main
RUN jupyter nbextension enable codefolding/main
RUN jupyter nbextension enable code_font_size/code_font_size
RUN jupyter nbextension enable code_prettify/code_prettify
RUN jupyter nbextension enable collapsible_headings/main
RUN jupyter nbextension enable comment-uncomment/main
RUN jupyter nbextension enable equation-numbering/main
RUN jupyter nbextension enable execute_time/ExecuteTime 
RUN jupyter nbextension enable gist_it/main 
RUN jupyter nbextension enable hide_input/main 
RUN jupyter nbextension enable spellchecker/main
RUN jupyter nbextension enable toc2/main
RUN jupyter nbextension enable toggle_all_line_numbers/main

CMD ["jupyter", "notebook", "--no-browser","--NotebookApp.token=''","--NotebookApp.password=''", "--allow-root"]

