FROM ubuntu:16.04
MAINTAINER Rahul Prajapati <rahul.prajapati90904@gmail.com>

#github https://github.com/LordVoldemort28/docker-deep-machine-learning

#Credit - waleedka/modern-deep-learning
#https://hub.docker.com/r/waleedka/modern-deep-learning/ 

# Supress warnings about missing front-end. As recommended at:
# http://stackoverflow.com/questions/22466255/is-it-possibe-to-answer-dialog-questions-when-installing-under-docker
ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \ 
    apt-utils \ 
    git \ 
    curl \ 
    vim \ 
    unzip \ 
    wget \
    build-essential cmake \ 
    libopenblas-dev 

# Python 3.5
# For convenience, alias (but don't sym-link) python & pip to python3 & pip3 as recommended in:
# http://askubuntu.com/questions/351318/changing-symlink-python-to-python3-causes-problems
RUN apt-get install -y --no-install-recommends \
    python3.5 \
    python3.5-dev \
    python3-pip \
    python3-tk \
    && pip3 install --no-cache-dir --upgrade pip setuptools \
    && echo "alias python='python3'" >> /root/.bash_aliases \
    && echo "alias pip='pip3'" >> /root/.bash_aliases

# Pillow and it's dependencies
RUN apt-get install -y --no-install-recommends libjpeg-dev zlib1g-dev && \
    pip3 --no-cache-dir install Pillow

# Science libraries and other common packages
RUN pip3 --no-cache-dir install \
    numpy scipy sklearn scikit-image pandas matplotlib Cython requests

# PyTorch
RUN pip3 install --no-cache-dir --upgrade torch torchvision

# Tensorflow 2.1.0
RUN pip3 install --no-cache-dir --upgrade tensorflow 

# Expose port for TensorBoard
EXPOSE 6006

# Java
RUN apt-get install -y --no-install-recommends default-jdk

# Keras 2.3.1
RUN pip3 install --no-cache-dir --upgrade h5py pydot_ng keras

# PyCocoTools
RUN pip3 install --no-cache-dir --upgrade pycocotools


ENV NCCL_VERSION 2.5.6
ENV CUDA_PKG_VERSION 10.2

RUN apt-get update && apt-get install -y --no-install-recommends \
    cuda-libraries-$CUDA_PKG_VERSION \
cuda-nvtx-$CUDA_PKG_VERSION \
libcublas10=10.2.2.89-1 \
libnccl2=$NCCL_VERSION-1+cuda10.2 && \
    apt-mark hold libnccl2 && \
    rm -rf /var/lib/apt/lists/*


RUN pip install --upgrade pip

WORKDIR "/root"
CMD ["/bin/bash"]
