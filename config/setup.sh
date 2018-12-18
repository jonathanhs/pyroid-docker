#!/bin/bash

# setup environments:
# 1. install nginx and other required libraries
# 2. install pip and pipenv
# 3. create project directory and copy nginx config
# 4. install django packages
# 5. install flask packages
# 6. remove unused directories and files

# 1. --------------------------------------------------------------------------
apt-key add /tmp/nginx_signing.key
add-apt-repository "deb http://nginx.org/packages/ubuntu/ bionic nginx"
apt-get update && apt-get install -y nginx python3-distutils
apt-get -y autoremove && apt-get clean
rm -rf /var/lib/apt/lists/*

# 2. --------------------------------------------------------------------------
python3 /tmp/get-pip.py
pip install pipenv

# 3. --------------------------------------------------------------------------
HOME=/root
mkdir $HOME/django_app $HOME/flask_app
cp /tmp/nginx/default.conf /etc/nginx/conf.d/default.conf

# 4. --------------------------------------------------------------------------
cd $HOME/django_app && cp /tmp/django/requirements.txt .
pipenv install -r requirements.txt
mkdir app && cp -R /tmp/django/app/* app

# 5. --------------------------------------------------------------------------
cd $HOME/flask_app && cp /tmp/flask/requirements.txt .
pipenv install -r requirements.txt
mkdir app && cp -R /tmp/flask/app/* app

# 6. --------------------------------------------------------------------------
rm -rf /tmp/django /tmp/flask /tmp/nginx
rm /tmp/get-pip.py /tmp/nginx_signing.key
