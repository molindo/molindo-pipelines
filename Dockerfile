FROM maven:3-jdk-8

RUN apt-get update \
        && apt-get install -y ant jshon python-pip python-dev \
        && pip install awscli \
        && apt-get clean \
        && rm -rf /var/lib/apt/lists/*

# initialize local repository
RUN git clone --depth=1 --branch v1.4.5.RELEASE https://github.com/spring-projects/spring-boot.git /tmp/spring-boot \
        && mvn -B \
            -s /usr/share/maven/ref/settings-docker.xml \
            -f /tmp/spring-boot/spring-boot-samples/pom.xml \
            --projects .,spring-boot-sample-data-jpa,spring-boot-sample-data-rest,spring-boot-sample-secure-oauth2 \
            dependency:resolve \
        && rm -r /tmp/spring-boot

ADD bin /usr/local/bin
