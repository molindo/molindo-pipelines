FROM maven:3-jdk-8

RUN apt-get update \
        && apt-get install -y ant jshon python-pip python-dev \
        && pip install awscli \
        && apt-get clean \
        && rm -rf /var/lib/apt/lists/*

ADD init.sh /tmp/init.sh
RUN /tmp/init.sh && rm /tmp/init.sh

ADD bin /usr/local/bin
