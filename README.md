# Couchbase Benchmarks

Install and benchmark Couchbase on various infrastructure providers.

See details for how to execute on various providers below. The default resource size is selected by price, with a goal to hit $0.120/hour or less. This typically selects for containers with about 4GB of RAM, though the number of CPUs varies. Feel free to change and test different resource sizes.

### Joyent Triton infrastructure container

Create an infrastructure container running container-optimize CentOS:

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

The `--script=./couchbase-install-triton-centos.bash` argument in the command string above _should_ install it, but that doesn't seem to be working now. Instead, ssh in and manually execute the installer script.

Lookup the IP address for this new instance and ssh in:

```bash
ssh root@$(sdc-listmachines --url=https://us-east-3b.api.joyent.com | json -a -c "this.name === 'couchbase-container-benchmarks-1'" ips.1)
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
    --url=https://us-east-2.api.joyent.com \
    --name=couchbase-vm-benchmarks-1 \
    --image=$(sdc-listimages --url=https://us-east-2.api.joyent.com | json -a -c "this.name === 'lx-centos-6'" id) \
    --package=$(sdc-listpackages --url=https://us-east-2.api.joyent.com | json -a -c '/^g/.test(this.name)' -c '/standard/.test(this.name)' -c '/(kvm)$/.test(this.name)' -c "this.memory === 4096" id) \
    --networks=$(sdc-listnetworks --url=https://us-east-2.api.joyent.com | json -a -c "this.name ==='Joyent-SDC-Private'" id) \
    --networks=$(sdc-listnetworks --url=https://us-east-2.api.joyent.com | json -a -c "this.name ==='Joyent-SDC-Public'" id) \
    --script=./couchbase-install-triton-centos.bash
```

The `--script=./couchbase-install-triton-centos.bash` argument in the command string above _should_ install it, but that doesn't seem to be working now. Instead, ssh in and manually execute the installer script.

Lookup the IP address for this new instance and ssh in:

```bash
ssh root@$(sdc-listmachines | json -a -c "this.name === 'couchbase-vm-benchmarks-1'" ips.1)
```

Execute the installer:

```bash
curl https://raw.githubusercontent.com/misterbisson/couchbase-benchmark/master/bin/install-triton-centos.bash | bash
```

### AWS

Create a VM running CentOS:

```bash
# Keyname and instance type
export AWSKEYNAME=my-aws-key-name
export AWSINSTANCETYPE=c4.large

# Creating a security group for testing
aws ec2 create-security-group --group-name couchbase-benchmarks --description "For benchmarking Couchbase, opens ports that should not be open in production"
aws ec2 authorize-security-group-ingress --group-name couchbase-benchmarks --protocol tcp --port 22 --cidr 0.0.0.0/0
aws ec2 authorize-security-group-ingress --group-name couchbase-benchmarks --protocol tcp --port 8091 --cidr 0.0.0.0/0

# Creating the VM instance
AWSIID=$(aws ec2 run-instances \
    --image-id ami-e7527ed7 \
    --count 1 \
    --instance-type $AWSINSTANCETYPE \
    --key-name $AWSKEYNAME \
    --security-group-ids $(aws ec2 describe-security-groups --group-names couchbase-benchmarks | json -a SecurityGroups.0.GroupId) | \
json -aH Instances.0.InstanceId)
```

Then ssh in to the newly created instance:

```bash
ssh ec2-user@$(aws ec2 describe-instances --instance-ids $AWSIID | json -a Reservations.0.Instances.0.PublicDnsName)
```

Execute the installer:

```bash
curl https://raw.githubusercontent.com/misterbisson/couchbase-benchmark/master/bin/install-aws-amazonlinux.bash | sudo bash
```