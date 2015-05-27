# Couchbase Benchmarks

### Joyent Triton infrastructure container

Create an infrastructure container running container-optimize CentOS:

```bash
curl -o couchbase-install-triton-centos.bash https://raw.githubusercontent.com/misterbisson/couchbase-benchmark/master/bin/install-triton-centos.bash
sdc-createmachine \
    --name=couchbase-container-benchmarks-1 \
    --image=$(sdc-listimages | json -a -c "this.name === 'lx-centos-6'" id) \
    --package=$(sdc-listpackages | json -a -c '/^g/.test(this.name)' -c '/standard/.test(this.name)' -c '/[^(kvm)]$/.test(this.name)' -c "this.memory === 4096" id) \
    --networks=$(sdc-listnetworks | json -a -c "this.name ==='Joyent-SDC-Private'" id) \
    --networks=$(sdc-listnetworks | json -a -c "this.name ==='Joyent-SDC-Public'" id) \
    --script=./couchbase-install-triton-centos.bash
```

Install Couchbase

The `--script=./couchbase-install-triton-centos.bash` argument in the command string above _should_ install it, but that doesn't seem to be working now. Instead, ssh in and manually execute the installer script.

Lookup the IP address for this new instance and ssh in:

```bash
ssh root@$(sdc-listmachines | json -a -c "this.name === 'couchbase-container-benchmarks-1'" ips.1)
```

Execute the installer:

```bash
curl https://raw.githubusercontent.com/misterbisson/couchbase-benchmark/master/bin/install-triton-centos.bash | bash
```

### Joyent Triton virtual machine

Create a VM running CentOS:

```bash
curl -o couchbase-install-triton-centos.bash https://raw.githubusercontent.com/misterbisson/couchbase-benchmark/master/bin/install-triton-centos.bash
sdc-createmachine \
    --name=couchbase-vm-benchmarks-1 \
    --image=$(sdc-listimages | json -a -c "this.name === 'lx-centos-6'" id) \
    --package=$(sdc-listpackages | json -a -c '/^g/.test(this.name)' -c '/standard/.test(this.name)' -c '/(kvm)$/.test(this.name)' -c "this.memory === 4096" id) \
    --networks=$(sdc-listnetworks | json -a -c "this.name ==='Joyent-SDC-Private'" id) \
    --networks=$(sdc-listnetworks | json -a -c "this.name ==='Joyent-SDC-Public'" id) \
    --script=./couchbase-install-triton-centos.bash
```

Install Couchbase

The `--script=./couchbase-install-triton-centos.bash` argument in the command string above _should_ install it, but that doesn't seem to be working now. Instead, ssh in and manually execute the installer script.

Lookup the IP address for this new instance and ssh in:

```bash
ssh root@$(sdc-listmachines | json -a -c "this.name === 'couchbase-vm-benchmarks-1'" ips.1)
```

Execute the installer:

```bash
curl https://raw.githubusercontent.com/misterbisson/couchbase-benchmark/master/bin/install-triton-centos.bash | bash
```
