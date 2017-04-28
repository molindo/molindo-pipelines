#!/bin/bash -e

cd /tmp

# initialize local repository with spring-boot-samples
for tag in v1.4.{2..6}.RELEASE v1.5.{0..3}.RELEASE; do
    git clone --depth=1 --branch $tag https://github.com/spring-projects/spring-boot.git spring-boot
    (
        cd spring-boot/spring-boot-samples
        mvn --batch-mode \
            --settings /usr/share/maven/ref/settings-docker.xml \
            --projects .,spring-boot-sample-data-jpa,spring-boot-sample-data-rest,spring-boot-sample-secure-oauth2 \
            dependency:resolve dependency:resolve-plugins
    )
    rm -rf spring-boot
done
