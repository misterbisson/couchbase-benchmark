# Joyent Triton infrastructure container

### Create an infrastructure container running container-optimized CentOS

```bash
curl -sL -o couchbase-install-triton-centos.bash https://raw.githubusercontent.com/misterbisson/couchbase-benchmark/master/bin/install-triton-centos.bash
sdc-createmachine \
    --url=https://us-east-3b.api.joyent.com  \
    --name=couchbase-container-benchmarks-1 \
    --image=$(sdc-listimages --url=https://us-east-3b.api.joyent.com | json -a -c "this.name === 'lx-centos-6'" id) \
    --package=$(sdc-listpackages --url=https://us-east-3b.api.joyent.com | json -a -c "this.memory === 8192" id) \
    --networks=$(sdc-listnetworks --url=https://us-east-3b.api.joyent.com | json -a -c "this.name ==='default'" id) \
    --networks=$(sdc-listnetworks --url=https://us-east-3b.api.joyent.com | json -a -c "this.name ==='Joyent-SDC-Public'" id) \
    --script=./couchbase-install-triton-centos.bash
```

### Install and configure Couchbase

Lookup the IP address for this new instance:

```bash
sdc-listmachines --url=https://us-east-3b.api.joyent.com | json -a -c "this.name === 'couchbase-container-benchmarks-1'" ips.1
```

...or look it up and and ssh in one step:

```bash
ssh root@$(sdc-listmachines --url=https://us-east-3b.api.joyent.com | json -a -c "this.name === 'couchbase-container-benchmarks-1'" ips.1)
```

...or this will poll for the IP, then ssh in after it's up

```bash
echo -n "Waiting for host."; CONTAINERIP=''; while [ "$CONTAINERIP" == '' ]; do echo -n '.'; CONTAINERIP=$(sdc-listmachines --url=https://us-east-3b.api.joyent.com | json -a -c "this.name === 'couchbase-container-benchmarks-1'" ips.1); sleep 0.7; done; echo; echo "Host created: $CONTAINERIP"; echo -n "Waiting for ssh to start."; for i in {1..7}; do echo -n '.'; sleep 0.7; done; echo; ssh root@$CONTAINERIP
```

Install and configure Couchbase:

```bash
curl -sL https://raw.githubusercontent.com/misterbisson/couchbase-benchmark/master/bin/install-triton-centos.bash | bash
```

The script should output some information about Couchbase and how to connect to the dashboard when complete. Take a moment to open the dashboard now so you can watch the output there while running the benchmark series.

### Run the benchmarks

The benchmarks will load a large data set and execute a set of queries designed by [decimal.io](http://www.decimal.io)'s [Corbin Uselton](https://github.com/corbinu) to test relative performance. As the benchmarks execute, look at the time to load data and query it. **Shorter times are better.**

Install the benchmarking tool and execute the benchmarks:

```bash
curl -sL https://raw.githubusercontent.com/misterbisson/couchbase-benchmark/master/bin/benchmark.bash | bash
```

The result should look similar to the following:

```
series 1: load test docs [====================] 300000/300000 100% 4.6s elapsed
completed series 1

series 2: load test docs [====================] 300000/300000 100% 4.4s elapsed
completed series 2

series 3: load test docs [====================] 300000/300000 100% 4.4s elapsed
completed series 3

series 4: load test docs [====================] 300000/300000 100% 4.5s elapsed
completed series 4

series 5: load test docs [====================] 300000/300000 100% 4.4s elapsed
completed series 5

series 6: load test docs [====================] 300000/300000 100% 4.5s elapsed
completed series 6

series 7: load test docs [====================] 300000/300000 100% 4.9s elapsed
completed series 7

series 8: load test docs [====================] 300000/300000 100% 4.4s elapsed
completed series 8
query people with SUVs
people with SUVs: 342732
people with SUVs in: 4621ms
query number of convertibles
number of convertibles: 342446
number of convertibles in: 132ms
query average age
average age: 42
average age: 129ms
waiting 60 seconds to run queries again
query people with SUVs
people with SUVs: 342732
people with SUVs in: 4111ms
query number of convertibles
number of convertibles: 342446
number of convertibles in: 130ms
query average age
average age: 42
average age: 129ms
```
