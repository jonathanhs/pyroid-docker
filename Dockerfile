## BUILDER
FROM ubuntu:18.04 as builder

# update and install required packages
RUN apt-get update && apt-get install -y curl \
    && apt-get -y autoremove && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && curl https://bootstrap.pypa.io/get-pip.py -o /tmp/get-pip.py \
    && curl https://nginx.org/keys/nginx_signing.key -o /tmp/nginx_signing.key

## FINAL BUILD
FROM jonathanhs/dev-vim:0.1-ub18.04
LABEL maintainer="jonathan.hadisuryo@gmail.com"

# set required environment
ENV LANG="C.UTF-8"
ENV LC_ALL="C.UTF-8"

# update and install required packages
COPY --from=builder /tmp/get-pip.py /tmp/get-pip.py
COPY --from=builder /tmp/nginx_signing.key /tmp/nginx_signing.key
RUN apt-key add /tmp/nginx_signing.key \
    && add-apt-repository "deb http://nginx.org/packages/ubuntu/ bionic nginx" \
    && apt-get update && apt-get install -y nginx python3-distutils \
    && apt-get -y autoremove && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && python3 /tmp/get-pip.py \
    && pip install pipenv \
    && rm /tmp/get-pip.py /tmp/nginx_signing.key

# expose ports
EXPOSE 80 443

# start nginx server
CMD ["nginx", "-g", "daemon off;"]
