FROM python:3.7-slim

LABEL maintainer="Tasimba Chirindo"

# update packages and install app server
RUN apt-get update
# uWSGI is a C application, so you need a C compiler (like gcc or clang) and the Python development headers for deployments on Debian-based distros.
RUN apt-get install -y build-essential python3-dev nginx
RUN pip install uwsgi

# copy across the updated nginx webserver config
RUN rm -v /etc/nginx/nginx.conf
ADD nginx-webserver-config/nginx.conf /etc/nginx/

# copy across python application code
COPY code ./application
WORKDIR /application

RUN pip install -r requirements.txt

COPY nginx-webserver-config/nginx.conf /etc/nginx/sites-enabled/default

CMD service nginx start && uwsgi -s /tmp/uwsgi.sock --chmod-socket=666 --manage-script-name --mount /=app:app