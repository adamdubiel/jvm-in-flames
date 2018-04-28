#!/bin/bash

#### Java 8

echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | sudo /usr/bin/debconf-set-selections
add-apt-repository -y ppa:webupd8team/java

#### download and install all packages

apt-get update
apt-get install -y oracle-java8-installer

# reload env to get proper Java variables
exec bash

#### Kafka

KAFKA_VERSION=0.10.2.1
SCALA_VERSION=2.10

if [ ! -d /opt/kafka ]; then
    echo "Installing Apache Kafka ${KAFKA_VERSION}"
    mirror=$(curl -sS https://www.apache.org/dyn/closer.cgi\?as_json\=1 | jq -r '.preferred')
    url="${mirror}kafka/${KAFKA_VERSION}/kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz"
    curl -sS ${url} --output /tmp/kafka.tgz

    tar xzf /tmp/kafka.tgz -C /opt
    rm /tmp/kafka.tgz
    mv /opt/kafka_${SCALA_VERSION}-${KAFKA_VERSION} /opt/kafka

    pip install zk-shell
else
    echo "Apache Kafka ${KAFKA_VERSION} already installed"
fi
