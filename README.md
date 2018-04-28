JVM in flames
-----

Vagrant box used to prepare materials for my *JVM in flames* talk.

### Box contains

Environment:

* Java 8
* [hermes-frontend](https://hermes.allegro.tech) module for testing
* [Kafka 0.10.2](https://kafka.apache.org) required by Hermes
* [wrk2](https://github.com/giltene/wrk2) traffic generator

Profilers & tools:

* [async-profiler](https://github.com/jvm-profiling-tools/async-profiler)
* [honest-profiler](https://github.com/jvm-profiling-tools/honest-profiler)
* [hprof2flamegraph](https://github.com/cykl/hprof2flamegraph) to generate flamegraphs from hpl and hprof files
* [perf-map-agent](https://github.com/jvm-profiling-tools/perf-map-agent) perf for Java; not included in talk
* [FlameGraph](https://github.com/brendangregg/FlameGraph) library for `perf-map-agent`

### Setup

```
vagrant up
```

### Running tests

Hermes Frontend binaries and run script are located in `/opt`. Everything should be run as `root`.

To run Hermes Frontend use `/opt/run-hermes.sh`. It can be also modified to change run arguments,
see commented out sections for ways to enable different profilers and measurement options.

All profilers are located in `/opt/profilers` and are ready to use (compiled etc).

#### Warmup

After Hermes Frontend starts, run in separate shell:

```
wrk -t5 -d20s -c20 -R1000 -L -s hermes-traffic.lua http://localhost:8080/topics/jvm-in-flames.topic
```

Warmup round generates 1000rps for 20 seconds.

#### Measurements

```
wrk -t10 -d300s -c20 -R2500 -L -s hermes-traffic.lua http://localhost:8080/topics/jvm-in-flames.topic
```

Measurements round lasts for 5 minutes, generates 2500rps. Higher percentiles are very sensitive to
any external activities, so best close all CPU-intensive apps like internet browser or IDE.

### Results

Sample results used in talk are in `./results` directory. Naming conventions:

* `vanilla` - no profilers
* `jmx`: JVisual VM profiler connected via JMX from host
* `hprof-10`: hprof profiler with default sampling interval (10ms)
* `hprof-100`: hprof profiler with sampling interval = 100ms
* `async`: async-profiler
* `honest`: honest-profiler

Directories:

* `results/flamegraphs`: flamegraphs in SVG format
* `results/hdr`: results from wrk2 traffic generator, compatible with [HDR Histogram](http://hdrhistogram.org/) plotter
* `results/gclog`: GC logs
