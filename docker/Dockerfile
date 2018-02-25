FROM ubuntu:16.04

MAINTAINER Bartlomiej Nogas <bart.nogas@gmail.com>

# Install required packets via apt-get
RUN apt-get update && apt-get install -y \
    libmysqlclient-dev \
    nginx \
    python3-pip \
    python3-virtualenv \
    virtualenv \
 && rm -rf /var/lib/apt/lists/*

ENV PROJECT_PATH=/opt/notejam
ENV PROJECT_EXEC=$PROJECT_PATH/virt/bin/notejam
ENV DJANGO_SETTINGS_MODULE="settings.docker"
WORKDIR $PROJECT_PATH

ADD requirements $PROJECT_PATH/requirements
ADD Makefile $PROJECT_PATH/Makefile

ADD docker/configs/gunicorn.py.ini $PROJECT_PATH/gunicorn.py.ini
ADD docker/start_app.sh $PROJECT_PATH/
ADD docker/configs/nginx.conf /etc/nginx/sites-available/django_nginx.conf
RUN ln -s /etc/nginx/sites-available/django_nginx.conf /etc/nginx/sites-enabled
RUN rm /etc/nginx/sites-enabled/default
RUN echo "daemon off;" >> /etc/nginx/nginx.conf


RUN chmod +x $PROJECT_PATH/start_app.sh


RUN mkdir -p $PROJECT_PATH/static

ADD . $PROJECT_PATH/notejam

RUN virtualenv --python=/usr/bin/python3.5 --no-wheel $PROJECT_PATH/virt
RUN cd $PROJECT_PATH/notejam; . ../virt/bin/activate; make install-docker-reqs
RUN cd $PROJECT_PATH/notejam; . ../virt/bin/activate; pip install -e .

# Configure entrypoint
ADD docker/entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
CMD $PROJECT_PATH/start_app.sh
