# Joyent Triton virtual machine

### Create a VM running CentOS

```bash
curl -sL -o couchbase-install-triton-centos.bash https://raw.githubusercontent.com/misterbisson/couchbase-benchmark/master/bin/install-triton-centos.bash
sdc-createmachine \
    --url=https://us-east-2.api.joyent.com \
    --name=couchbase-vm-benchmarks-1 \
    --image=$(sdc-listimages --url=https://us-east-2.api.joyent.com | json -a -c "this.name === 'lx-centos-6'" id) \
    --package=$(sdc-listpackages --url=https://us-east-2.api.joyent.com | json -a -c '/^g/.test(this.name)' -c '/highmemory/.test(this.name)' -c '/(kvm)$/.test(this.name)' -c "this.memory === 17536" id) \
    --networks=$(sdc-listnetworks --url=https://us-east-2.api.joyent.com | json -a -c "this.name ==='Joyent-SDC-Private'" id) \
    --networks=$(sdc-listnetworks --url=https://us-east-2.api.joyent.com | json -a -c "this.name ==='Joyent-SDC-Public'" id) \
    --script=./couchbase-install-triton-centos.bash
```

### Install and configure Couchbase

The `--script=./couchbase-install-triton-centos.bash` argument in the command string above _should_ install it, but that doesn't seem to be working now. Instead, ssh in and manually execute the installer script.

Lookup the IP address for this new instance and ssh in:

```bash
ssh root@$(sdc-listmachines --url=https://us-east-2.api.joyent.com | json -a -c "this.name === 'couchbase-vm-benchmarks-1'" ips.1)
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
series 1: load test docs [====================] 300000/300000 100% 35.3s elapsed
completed series 1

series 2: load test docs [====================] 300000/300000 100% 40.7s elapsed
completed series 2

series 3: load test docs [====================] 300000/300000 100% 37.7s elapsed
completed series 3

series 4: load test docs [====================] 300000/300000 100% 33.2s elapsed
completed series 4

series 5: load test docs [====================] 300000/300000 100% 34.1s elapsed
completed series 5

series 6: load test docs [====================] 300000/300000 100% 33.9s elapsed
completed series 6

series 7: load test docs [====================] 300000/300000 100% 35.1s elapsed
completed series 7

series 8: load test docs [====================] 300000/300000 100% 34.2s elapsed
completed series 8
query people with SUVs
people with SUVs: 342732
people with SUVs in: 20646ms
query number of convertibles
number of convertibles: 342446
number of convertibles in: 767ms
query average age
average age: 42
average age: 232ms
waiting 60 seconds to run queries again
query people with SUVs
people with SUVs: 342732
people with SUVs in: 23444ms
query number of convertibles
number of convertibles: 342446
number of convertibles in: 662ms
query average age
average age: 42
average age: 475ms
```