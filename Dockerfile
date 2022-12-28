FROM ubuntu:22.04
LABEL author="onur.yukselen@umassmed.edu"  description="Docker image containing all requirements for the pipeline"

ENV LANG=C.UTF-8 LC_ALL=C.UTF-8
ENV PATH /opt/conda/bin:$PATH

RUN apt-get update --fix-missing && \
    apt-get install -y wget bzip2 ca-certificates curl git libtbb-dev g++

RUN wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-4.5.11-Linux-x86_64.sh -O ~/miniconda.sh && \
    /bin/bash ~/miniconda.sh -b -p /opt/conda && \
    rm ~/miniconda.sh && \
    /opt/conda/bin/conda clean -tipsy && \
    ln -s /opt/conda/etc/profile.d/conda.sh /etc/profile.d/conda.sh && \
    echo ". /opt/conda/etc/profile.d/conda.sh" >> ~/.bashrc && \
    echo "conda activate base" >> ~/.bashrc

RUN apt-get update && apt-get install -y gcc unzip
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64-2.0.30.zip" -o "awscliv2.zip"
RUN unzip awscliv2.zip
RUN ./aws/install
RUN aws --version

RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/*

COPY environment.yml /
ARG MAMBA_DOCKERFILE_ACTIVATE=1
RUN . /opt/conda/etc/profile.d/conda.sh && \
    conda activate base && \
    conda update conda && \
    conda install -c conda-forge mamba && \
    mamba env update --name base -f /environment.yml && \
    mamba clean -a
ENV PATH /opt/conda/bin:$PATH
ENV PATH /usr/local/bin:$PATH
