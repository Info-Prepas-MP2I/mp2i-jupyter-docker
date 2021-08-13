FROM jupyter/base-notebook:2021-08-09

USER root

RUN apt-get update && apt install -y software-properties-common && add-apt-repository ppa:avsm/ppa \
    && apt install -y --no-install-recommends zlib1g-dev libffi-dev libgmp-dev libzmq5-dev pkg-config \
    build-essential curl sudo ocaml opam python3-pip \
    && rm -rf /var/lib/apt/lists/ \
    && curl -sSL https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh -o /tmp/miniconda.sh \
    && bash /tmp/miniconda.sh -bfp /usr/local \
    && rm -rf /tmp/miniconda.sh \
    && pip3 install nbgitpuller notebook sos-notebook \
    && python3 -m sos_notebook.install \
    && conda install -c conda-forge jupyterlab-sos xeus-cling

RUN opam init -a -y --disable-sandboxing \
    && opam update \
    && opam upgrade -y \
    && eval $(opam env) \
    && opam install -y jupyter \
    && opam exec -- ocaml-jupyter-opam-genspec \
    && jupyter kernelspec install --name ocaml-jupyter "$(opam config var share)/jupyter"

USER ${NB_USER}
WORKDIR ${HOME}
