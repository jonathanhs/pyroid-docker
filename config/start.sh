#!/bin/bash

HOME=/root

# activate virtualenv and start gunicorn wsgi
if [ $1 = django ]; then
    cd $HOME/django_app
    pipenv run gunicorn app.wsgi -w 4 -b 0.0.0.0:8000 --chdir=app --log-file - --daemon
elif [ $1 = flask ]; then
    cd $HOME/flask_app
    pipenv run gunicorn app.wsgi -w 4 -b 0.0.0.0:8000 --chdir=app --log-file - --daemon
fi

# start nginx server
nginx -g 'daemon off;'
