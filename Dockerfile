FROM unlhcc/cuda-ubuntu:10.2
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
    pip3 --no-cache-dir install 'pillow<7'

# Science libraries and other common packages
RUN pip3 --no-cache-dir install \
    numpy scipy sklearn scikit-image pandas matplotlib requests

# Install PyTorch (and friends) for both Python 3.5
RUN pip3 --no-cache-dir install 'torchvision==0.4.0' 'torch==1.2.0' torchsummary scikit-learn 'networkx==2.0'

# Java
RUN apt-get install -y --no-install-recommends default-jdk
# Cython
RUN pip3 install --no-cache-dir --upgrade Cython cython

# PyCocoTools
RUN pip3 install --no-cache-dir --upgrade pycocotools
# PrettyTable
RUN pip3 install --no-cache-dir --upgrade PrettyTable
# TensorBoardX
RUN pip3 install --no-cache-dir --upgrade tensorboard future
#Nvidia-dali
RUN pip install --extra-index-url https://developer.download.nvidia.com/compute/redist/cuda/10.0 nvidia-dali

EXPOSE 6006

RUN pip install --upgrade pip

WORKDIR "/root"
CMD ["/bin/bash"]
