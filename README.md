# Couchbase Cloud Benchmarks

### Joyent Triton

Create an infrastructure container running container-optimize CentOS:

```bash
curl -o couchbase-install-centos.bash https://raw.githubusercontent.com/misterbisson/couchbase-benchmark/master/bin/install-centos.bash
sdc-createmachine \
    --name=couchbase-cloud-benchmarks-1 \
    --image=$(sdc-listimages | json -a -c "this.name === 'lx-centos-6'" id) \
    --package=$(sdc-listpackages | json -a -c '/^g/.test(this.name)' -c '/[^(kvm)]$/.test(this.name)' -c "this.memory === 1024" id) \
    --networks=$(sdc-listnetworks | json -a -c "this.name ==='Joyent-SDC-Private'" id) \
    --networks=$(sdc-listnetworks | json -a -c "this.name ==='Joyent-SDC-Public'" id) \
    --script=./couchbase-install-centos.bash
```

Install Couchbase

The `--script=./couchbase-install-centos.bash` argument in the command string above _should_ install it.