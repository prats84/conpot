# ConPot Dockerfile by MO
#
# VERSION 16.03.1
FROM ubuntu:14.04.4
MAINTAINER MO

ENV DEBIAN_FRONTEND noninteractive

# Setup apt
RUN sed -i '1ideb mirror://mirrors.ubuntu.com/mirrors.txt trusty main universe multiverse' /etc/apt/sources.list && \
    sed -i '1ideb mirror://mirrors.ubuntu.com/mirrors.txt trusty-updates main universe multiverse' /etc/apt/sources.list && \
    sed -i '1ideb mirror://mirrors.ubuntu.com/mirrors.txt trusty-backports main universe multiverse' /etc/apt/sources.list && \
    sed -i '1ideb mirror://mirrors.ubuntu.com/mirrors.txt trusty-security main universe multiverse' /etc/apt/sources.list

RUN apt-get update -y && \
    apt-get upgrade -y

# Install packages
RUN apt-get install -y git libmysqlclient-dev libsmi2ldbl libxslt1-dev python python-dev snmp-mibs-downloader supervisor

# Setup ConPot
RUN cd /opt/ && \
    git clone https://github.com/mushorg/conpot.git && \
    cd conpot/ && \
    python setup.py install && \
    rm -rf /opt/conpot /tmp/* /var/tmp/*

# Setup user, groups and configs
RUN addgroup --gid 2000 tpot && \
    adduser --system --no-create-home --shell /bin/bash --uid 2000 --disabled-password --disabled-login --gid 2000 tpot
ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf
ADD conpot.cfg /etc/conpot/conpot.cfg

# Clean up
RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

CMD ["/usr/bin/supervisord"]
