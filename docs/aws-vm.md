# AWS

### Create a VM running CentOS

First, create a security group with the right ports open:

```bash
# Creating a security group for testing
aws ec2 create-security-group --group-name couchbase-benchmarks --description "For benchmarking Couchbase, opens ports that should not be open in production"
aws ec2 authorize-security-group-ingress --group-name couchbase-benchmarks --protocol tcp --port 22 --cidr 0.0.0.0/0
aws ec2 authorize-security-group-ingress --group-name couchbase-benchmarks --protocol tcp --port 8091 --cidr 0.0.0.0/0
```
Now we can create the VM:

```bash
# Keyname and instance type
export AWSKEYNAME=my-aws-key-name
export AWSINSTANCETYPE=c4.xlarge

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

Install and configure Couchbase:

```bash
curl -sL https://raw.githubusercontent.com/misterbisson/couchbase-benchmark/master/bin/install-aws-amazonlinux.bash | sudo bash
```

The script should output some information about Couchbase and how to connect to the dashboard when complete. Take a moment to open the dashboard now so you can watch the output there while running the benchmark series.

### Run the benchmarks

The benchmarks will load a large data set and execute a set of queries designed by [decimal.io](http://www.decimal.io)'s [Corbin Uselton](https://github.com/corbinu) to test relative performance. As the benchmarks execute, look at the time to load data and query it. **Shorter times are better.**

Install the benchmarking tool and execute the benchmarks:

```bash
curl -sL https://raw.githubusercontent.com/misterbisson/couchbase-benchmark/master/bin/benchmark.bash | sudo bash
```

The result should look similar to the following:

```
series 1: load test docs [====================] 300000/300000 100% 19.9s elapsed
completed series 1

series 2: load test docs [====================] 300000/300000 100% 21.5s elapsed
completed series 2

series 3: load test docs [====================] 300000/300000 100% 22.7s elapsed
completed series 3

series 4: load test docs [====================] 300000/300000 100% 22.7s elapsed
completed series 4

series 5: load test docs [====================] 300000/300000 100% 23.7s elapsed
completed series 5

series 6: load test docs [====================] 300000/300000 100% 24.2s elapsed
completed series 6

series 7: load test docs [====================] 300000/300000 100% 23.4s elapsed
completed series 7

series 8: load test docs [====================] 300000/300000 100% 23.4s elapsed
completed series 8
query people with SUVs
people with SUVs: 342732
people with SUVs in: 31646ms
query number of convertibles
number of convertibles: 342446
number of convertibles in: 1267ms
query average age
average age: 42
average age: 632ms
waiting 60 seconds to run queries again
query people with SUVs
people with SUVs: 342732
people with SUVs in: 29444ms
query number of convertibles
number of convertibles: 342446
number of convertibles in: 762ms
query average age
average age: 42
average age: 575ms
```