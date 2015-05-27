# AWS

### Create a VM running CentOS

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
### Install and configure Couchbase

Ssh in to the newly created instance:

```bash
ssh ec2-user@$(aws ec2 describe-instances --instance-ids $AWSIID | json -a Reservations.0.Instances.0.PublicDnsName)
```

Execute the installer:

```bash
curl https://raw.githubusercontent.com/misterbisson/couchbase-benchmark/master/bin/install-aws-amazonlinux.bash | sudo bash
```

### Run the benchmarks

```bash
/opt/couchbase/bin/cbworkloadgen -n 10.117.79.85:8091 -r .9 -i 100000 -s 100 --threads 10 -j
```