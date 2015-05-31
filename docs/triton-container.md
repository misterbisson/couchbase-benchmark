# Joyent Triton infrastructure container

### Create an infrastructure container running container-optimized CentOS

```bash
curl -o couchbase-install-triton-centos.bash https://raw.githubusercontent.com/misterbisson/couchbase-benchmark/master/bin/install-triton-centos.bash
sdc-createmachine \
    --url=https://us-east-3b.api.joyent.com  \
    --name=couchbase-container-benchmarks-1 \
    --image=$(sdc-listimages --url=https://us-east-3b.api.joyent.com | json -a -c "this.name === 'lx-centos-6'" id) \
    --package=$(sdc-listpackages --url=https://us-east-3b.api.joyent.com | json -a -c "this.memory === 4096" id) \
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
echo -n "Waiting for host."; while [ "$CONTAINERIP" == '' ]; do echo -n '.'; CONTAINERIP=$(sdc-listmachines --url=https://us-east-3b.api.joyent.com | json -a -c "this.name === 'couchbase-container-benchmarks-1'" ips.1); sleep 0.7; done; echo; echo "Host created: $CONTAINERIP"; echo -n "Waiting for ssh to start."; for i in {1..7}; do echo -n '.'; sleep 0.7; done; echo; ssh root@$CONTAINERIP
```

Install and configure Couchbase:

```bash
curl https://raw.githubusercontent.com/misterbisson/couchbase-benchmark/master/bin/install-triton-centos.bash | bash
```

### Run the benchmarks

```bash
curl https://raw.githubusercontent.com/misterbisson/couchbase-benchmark/master/bin/benchmark.bash | bash
```

### Known bug

Couchbase is trying to schedule across 48 CPUs, even though the container in the example above only has scheduling priority for two. That's causing performance bottlenecks.
