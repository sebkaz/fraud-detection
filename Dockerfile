# jupyter notebook without ubuntu

FROM python:3.8-slim
RUN python -m pip install --upgrade pip setuptools
RUN python -m pip --no-cache-dir install ipython jupyter
RUN python -m pip --no-cache-dir install tensorflow keras
RUN python -m pip --no-cache-dir install xgboost lightgbm
RUN python -m pip --no-cache-dir install sklearn scipy seaborn matplotlib

COPY . /notebooks/
# Configuring access to Jupyter
WORKDIR /notebooks/

# Configuring access to Jupyter

RUN jupyter notebook --generate-config --allow-root
RUN echo "c.NotebookApp.password = u'sha1:6a3f528eec40:6e896b6e4828f525a6e20e5411cd1c8075d68619'" >> /root/.jupyter/jupyter_notebook_config.py

# Add Tini. Tini operates as a process subreaper for jupyter. This prevents kernel crashes.
ENV TINI_VERSION v0.6.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /usr/bin/tini
RUN chmod +x /usr/bin/tini
ENTRYPOINT ["/usr/bin/tini", "--"]

# Jupyter listens port: 8888
EXPOSE 8888

# Run Jupyter notebook  without password - not recomended !!!
CMD ["jupyter", "notebook", "--allow-root", "--notebook-dir=/notebooks", "--ip='*'", "--port=8888", "--no-browser", "--NotebookApp.token=''"]
