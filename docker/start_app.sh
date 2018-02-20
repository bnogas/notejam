#!/bin/sh

set -x
set -e

. $PROJECT_PATH/virt/bin/activate
cd $PROJECT_PATH/notejam
notejam migrate --noinput
# python docker/create_superuser.py
gunicorn --config=$PROJECT_PATH/gunicorn.py.ini notejam.wsgi
