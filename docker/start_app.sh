#!/bin/sh

set -e

. ${PROJECT_PATH}/virt/bin/activate
cd ${PROJECT_PATH}/notejam
python3 ${PROJECT_PATH}/notejam/docker/get_credentials.py
. ${PROJECT_PATH}/secret_env.sh
. ${PROJECT_PATH}/db_config.sh
notejam migrate --noinput
notejam collectstatic --clear --noinput
notejam collectstatic --noinput
python ${PROJECT_PATH}/notejam/docker/create_superuser.py
tail -n0 -f /var/log/nginx/*log &
echo `sleep 5 ; service nginx start` &
gunicorn --config=${PROJECT_PATH}/gunicorn.py.ini notejam.wsgi

