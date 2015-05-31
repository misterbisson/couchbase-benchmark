# Joyent Triton virtual machine

### Create a VM running CentOS

```bash
curl -sL -o couchbase-install-triton-centos.bash https://raw.githubusercontent.com/misterbisson/couchbase-benchmark/master/bin/install-triton-centos.bash
sdc-createmachine \
    --url=https://us-east-2.api.joyent.com \
    --name=couchbase-vm-benchmarks-1 \
    --image=$(sdc-listimages --url=https://us-east-2.api.joyent.com | json -a -c "this.name === 'lx-centos-6'" id) \
    --package=$(sdc-listpackages --url=https://us-east-2.api.joyent.com | json -a -c '/^g/.test(this.name)' -c '/standard/.test(this.name)' -c '/(kvm)$/.test(this.name)' -c "this.memory === 4096" id) \
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

### Run the benchmarks

```bash
curl -sL https://raw.githubusercontent.com/misterbisson/couchbase-benchmark/master/bin/benchmark.bash | bash
```