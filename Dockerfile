FROM ubuntu:latest
MAINTAINER Manfred Touron "m@42.am"

# Set one or more individual labels
LABEL com.i-m-code.readthedocs.version="0.0.1-alpha"
LABEL com.i-m-code.readthedocs.release-date="12-20-2016"
LABEL com.i-m-code.readthedocs.license="MIT"
LABEL com.i-m-code.readthedocs.repo="frozenbytes"
LABEL com.i-m-code.readthedocs.baserepo="moul"

ENV DEBIAN_FRONTEND noninteractive
ENV APPDIR /app
ENV DJANGO_SETTINGS_MODULE config
ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8
ENV VIRTUAL_ENV /venv
ENV PATH /venv/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

# Set locale to UTF-8
RUN locale-gen en_US.UTF-8 && \
    update-locale LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8

# Update python
RUN apt-get -qq update && \
    apt-get -y -qq upgrade && \
    apt-get install -y -qq \
        python libxml2-dev libxslt1-dev expat libevent-dev wget python-dev \
        texlive texlive-latex-extra language-pack-en unzip git python-pip \
        zlib1g-dev lib32z1-dev libpq-dev gettext curl apt-utils && \
    apt-get clean

# Install test dependencies
RUN pip install -q \
    virtualenv \
    pep8 \
    mock \
    nose \
    coverage \
    pylint

# Setting up virtualenv
RUN virtualenv /venv

# Add user py
RUN adduser --gecos 'py' --disabled-password py

RUN mkdir -p $APPDIR && cd /tmp && \
    wget -q --no-check-certificate https://github.com/rtfd/readthedocs.org/archive/master.zip 

ADD config /

RUN /bin/rtd-install.sh

# Install gunicorn web server
# RUN pip install gunicorn
RUN pip install setproctitle

# Set up the gunicorn startup script
COPY /bin/gunicorn_start.sh ./gunicorn_start.sh
RUN chmod u+x ./gunicorn_start.sh

# Install supervisord
RUN pip install supervisor
ADD /bin/supervisord.conf /etc/supervisord.conf

ENV RTD_PRODUCTION_DOMAIN 'localhost:8000'

# Set up nginx
COPY /bin/readthedocs.nginx.conf /etc/nginx/sites-available/readthedocs
RUN ln -s /etc/nginx/sites-available/readthedocs /etc/nginx/sites-enabled/readthedocs

# Docker config
EXPOSE 8000
VOLUME ["/app"]
CMD ["/bin/rtd-start.sh"]
