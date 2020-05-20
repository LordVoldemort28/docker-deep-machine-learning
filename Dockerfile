FROM ubuntu:16.04
MAINTAINER Rahul Prajapati <rahul.prajapati90904@gmail.com>

#github https://github.com/LordVoldemort28/docker-deep-machine-learning

#Credit - waleedka/modern-deep-learning
#https://hub.docker.com/r/waleedka/modern-deep-learning/ 

# Supress warnings about missing front-end. As recommended at:
# http://stackoverflow.com/questions/22466255/is-it-possibe-to-answer-dialog-questions-when-installing-under-docker
ARG DEBIAN_FRONTEND=noninteractive

# Install wget and build-essential
RUN apt-get update && apt-get install -y -qq \
    software-properties-common \
    gnupg-curl \
    module-init-tools \
    build-essential

RUN apt-get update && apt-get install -y --no-install-recommends \ 
    apt-utils \ 
    git \ 
    curl \ 
    vim \ 
    unzip \ 
    wget \
    build-essential \
    cmake \ 
    clang-8 \
    libopenblas-dev 

RUN wget -q https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1604/x86_64/cuda-ubuntu1604.pin && \
    mv cuda-ubuntu1604.pin /etc/apt/preferences.d/cuda-repository-pin-600 && \
    apt-key adv --fetch-keys http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1604/x86_64/7fa2af80.pub && \
    add-apt-repository "deb http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1604/x86_64/ /" && \
    wget http://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu1604/x86_64/nvidia-machine-learning-repo-ubuntu1604_1.0.0-1_amd64.deb && \
    apt install ./nvidia-machine-learning-repo-ubuntu1604_1.0.0-1_amd64.deb && \
    apt-get -qq update && \
    apt-get install -y -qq cuda-toolkit-10-2 libcudnn7=7.6.5.32-1+cuda10.2 libcudnn7-dev=7.6.5.32-1+cuda10.2 \
        libnvinfer6=6.0.1-1+cuda10.2 libnvinfer-dev=6.0.1-1+cuda10.2 libnvinfer-plugin6=6.0.1-1+cuda10.2 \
        libnccl2=2.6.4-1+cuda10.2 libnccl-dev=2.6.4-1+cuda10.2

ENV PATH=/usr/local/cuda/bin:$PATH \
    LD_LIBRARY_PATH=/usr/local/cuda/lib64:$LD_LIBRARY_PATH \
    CUDA_HOME=/usr/local/cuda \
    LC_ALL=C

RUN mkdir /work /common

# #clang-8
# RUN wget https://releases.llvm.org/8.0.0/clang+llvm-8.0.0-x86_64-linux-gnu-ubuntu-16.04.tar.xz \
#     && tar -xvf clang+llvm-8.0.0-x86_64-linux-gnu-ubuntu-16.04.tar.xz \
#     && cd clang+llvm-8.0.0-x86_64-linux-gnu-ubuntu-16.04 \
#     && cp -R ./* /usr/local/

# Python 3.6
# For convenience, alias (but don't sym-link) python & pip to python3 & pip3 as recommended in:
# http://askubuntu.com/questions/351318/changing-symlink-python-to-python3-causes-problems
RUN apt-get install software-properties-common \
    && add-apt-repository ppa:deadsnakes/ppa \
    && apt-get update \
    && apt-get install -y --no-install-recommends\
    python3.5 \
    python3-pip \
    && pip3 install --no-cache-dir --upgrade pip setuptools \
    && echo "alias python='python3'" >> /root/.bash_aliases \
    && echo "alias pip='pip3'" >> /root/.bash_aliases

#Conda
RUN wget --quiet https://repo.anaconda.com/archive/Anaconda3-5.3.0-Linux-x86_64.sh -O ~/anaconda.sh && \
    /bin/bash ~/anaconda.sh -b -p /opt/conda && \
    rm ~/anaconda.sh && \
    ln -s /opt/conda/etc/profile.d/conda.sh /etc/profile.d/conda.sh && \
    echo ". /opt/conda/etc/profile.d/conda.sh" >> ~/.bashrc && \
    echo "conda activate base" >> ~/.bashrc

# Pillow and it's dependencies
RUN apt-get install -y --no-install-recommends libjpeg-dev zlib1g-dev && \
    pip3 --no-cache-dir install 'pillow<7' pyyaml

# Science libraries and other common packages
RUN pip3 --no-cache-dir install \
    numpy scipy sklearn scikit-image pandas matplotlib requests

# Java
RUN apt-get install -y --no-install-recommends default-jdk

# Cython
RUN pip3 install --no-cache-dir --upgrade Cython cython 

RUN pip3 install --no-cache-dir --upgrade PrettyTable tensorboard future

RUN git clone --recursive https://github.com/pytorch/pytorch \
    && mv /pytorch /home

RUN export PATH="/opt/conda/bin:$PATH" \
    && export CMAKE_PREFIX_PATH=${CONDA_PREFIX:-"$(dirname $(which conda))/../"} \
    && cd /home/pytorch \
    && python3 setup.py install 

# Install PyTorch (and friends) for both Python 3.5
RUN pip3 --no-cache-dir install 'networkx==2.0' 'torchvision==0.4.0'

EXPOSE 6006

RUN pip install --upgrade pip

WORKDIR "/root"
CMD ["/bin/bash"]
