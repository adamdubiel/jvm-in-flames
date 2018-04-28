#!/bin/bash

#### Hermes

export HERMES_VERSION=0.12.4

if [ ! -d /home/vagrant/hermes ]; then

    # build hermes-frontend & management
    (
        git clone https://github.com/allegro/hermes.git
        cd hermes
        git checkout hermes-$HERMES_VERSION

        sed -i 's/162/172/' integration/build.gradle

        ./gradlew --no-daemon :hermes-frontend:distZip :hermes-management:distZip -Pdistribution -x test -x integrationTest
    )

    # move distributions
    cp /home/vagrant/hermes/hermes-frontend/build/distributions/hermes-frontend-$HERMES_VERSION.zip /opt/
    unzip /opt/hermes-frontend-$HERMES_VERSION.zip -d /opt

    cp /home/vagrant/hermes/hermes-management/build/distributions/hermes-management-$HERMES_VERSION.zip /opt/
    unzip /opt/hermes-management-$HERMES_VERSION.zip -d /opt

    # move install scripts
    cp /tmp/vagrant-scripts/run-hermes.sh /opt/
    chmod +x /opt/run-hermes.sh

    # create topics
    pip install httpie

    nohup /opt/hermes-management-$HERMES_VERSION/bin/hermes-management > /dev/null 2>&1 & echo $! > /tmp/hermes-management.pid

    sleep 30s

    http POST :8090/groups groupName=jvm-in-flames
    http POST :8090/topics name=jvm-in-flames.topic description="Topic" contentType=JSON retentionTime:='{"duration": 1}' owner:='{"source": "Plaintext", "id": "Owner"}'

    kill `cat /tmp/hermes-management.pid`
fi
