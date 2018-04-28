#!/bin/bash


export JAVA_OPTS=" \
-ms512m -mx512m -XX:+UseConcMarkSweepGC \
-XX:+PrintGC -Xloggc:gc.log \
-XX:+UseGCLogFileRotation -XX:NumberOfGCLogFiles=5 \
-XX:GCLogFileSize=10M \
-XX:+PrintTenuringDistribution \
-XX:+PrintGCDetails \
-XX:+PrintGCDateStamps \
-XX:+PrintGCApplicationStoppedTime \
-XX:+PrintGCApplicationConcurrentTime \
"

# honest-profiler
# -agentpath:/home/vagrant/honest-profiler/build/liblagent.so=interval=7,logPath=/opt/honest-profile.hpl \

# hprof 10
# -agentlib:hprof=cpu=samples \

# hprof 100
# -agentlib:hprof=cpu=samples,interval=100 \

# JMX
# -Dcom.sun.management.jmxremote -Dcom.sun.management.jmxremote.port=9010 \
# -Dcom.sun.management.jmxremote.local.only=false \
# -Dcom.sun.management.jmxremote.authenticate=false \
# -Dcom.sun.management.jmxremote.ssl=false \
# -Djava.rmi.server.hostname=10.10.10.12 \

/opt/hermes-frontend-0.12.4/bin/hermes-frontend
