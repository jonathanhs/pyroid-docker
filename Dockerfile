## BUILDER 1
FROM ubuntu:18.04 as builder_pip

# update and install required packages
RUN apt-get update && apt-get install -y curl \
    && apt-get -y autoremove && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && curl https://bootstrap.pypa.io/get-pip.py -o /tmp/get-pip.py

## FINAL BUILD
FROM jonathanhs/dev-vim:0.1-ub18.04
LABEL maintainer="jonathan.hadisuryo@gmail.com"

# set required environment
ENV LANG="C.UTF-8"
ENV LC_ALL="C.UTF-8"

# update packages and install python3 packages
RUN apt-get update && apt-get install -y \
        software-properties-common \
        python3-distutils \
    && apt-get -y autoremove && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# copy pip installer and install both pip and pipenv
COPY --from=builder_pip /tmp/get-pip.py /tmp/get-pip.py
RUN python3 /tmp/get-pip.py \
    && rm /tmp/get-pip.py \
    && pip install pipenv
