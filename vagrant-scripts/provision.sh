#!/bin/bash

cd /home/vagrant

#### update and install all packages

KERNEL_VERSION=$(uname -r)

apt-get update
apt-get install -y htop sysstat unzip cmake libunittest++-dev maven pkg-config python-pip \
                   linux-tools-common linux-tools-$KERNEL_VERSION linux-cloud-tools-$KERNEL_VERSION build-essential libssl-dev \
                   jq supervisor

. /tmp/vagrant-scripts/provision-env.sh

#### supervisor

cp /tmp/vagrant-scripts/supervisor-apps.conf /etc/supervisor/conf.d/apps.conf
supervisorctl reload

####

. /tmp/vagrant-scripts/provision-hermes.sh
cp /tmp/vagrant-scripts/hermes-traffic.lua /opt/hermes-traffic.lua


#### wrk2

if [ ! -d /tmp/wrk2 ]; then
  (
    cd /tmp
    git clone https://github.com/giltene/wrk2.git
    cd wrk2
    make
    cp wrk /usr/local/bin
  )
fi

#### prepare profilers dir

mkdir -p /opt/profilers
cd /opt/profilers

#### flamegraphs

if [ ! -d /opt/profilers/FlameGraph ]; then
    git clone https://github.com/brendangregg/FlameGraph.git /opt/profilers/FlameGraph
    echo "FLAMEGRAPH_DIR=/opt/profilers/FlameGraph" >> /root/.bashrc
fi

#### perf-map-agent

if [ ! -d /opt/profilers/perf-map-agent ]; then
    git clone https://github.com/jvm-profiling-tools/perf-map-agent.git /opt/profilers/perf-map-agent
    (
        cd /opt/profilers/perf-map-agent
        cmake . && make
    )
fi

#### async-profiler

if [ ! -d /opt/profilers/async-profiler ]; then
    git clone https://github.com/jvm-profiling-tools/async-profiler.git /opt/profilers/async-profiler
    (
      cd /opt/profilers/async-profiler
      make
    )
fi

#### honest-profiler

if [ ! -d /opt/profilers/honest-profiler ]; then
    git clone https://github.com/jvm-profiling-tools/honest-profiler.git /opt/profilers/honest-profiler
    (
      cd /opt/profilers/honest-profiler
      cmake . && make
    )
fi

#### hprof2flamegraph

if [ ! -d /opt/profilers/hprof2flamegraph ]; then
    git clone https://github.com/cykl/hprof2flamegraph.git /opt/profilers/hprof2flamegraph
fi
