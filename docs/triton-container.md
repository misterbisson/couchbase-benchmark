# Joyent Triton infrastructure container

### Create an infrastructure container running container-optimized CentOS

```bash
sdc-createmachine \
    --url=https://us-east-3b.api.joyent.com  \
    --name=couchbase-container-benchmarks-1 \
    --image=$(sdc-listimages --url=https://us-east-3b.api.joyent.com | json -a -c "this.name === 'lx-centos-6'" id) \
    --package=$(sdc-listpackages --url=https://us-east-3b.api.joyent.com | json -a -c "this.memory === 4096" id) \
    --networks=$(sdc-listnetworks --url=https://us-east-3b.api.joyent.com | json -a -c "this.name ==='default'" id) \
    --networks=$(sdc-listnetworks --url=https://us-east-3b.api.joyent.com | json -a -c "this.name ==='Joyent-SDC-Public'" id)
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

Execute the installer:

```bash
echo -e "$(curl -s https://raw.githubusercontent.com/misterbisson/couchbase-benchmark/master/bin/install-triton-centos-env.bash)" >> .bash_profile && source .bash_profile
curl https://raw.githubusercontent.com/misterbisson/couchbase-benchmark/master/bin/install-triton-centos.bash | bash
```

### Run the benchmarks

```bash
/opt/couchbase/bin/cbworkloadgen -n 127.0.0.1:8091 -r .9 -i 100000 -s 100 --threads 10 -j
```