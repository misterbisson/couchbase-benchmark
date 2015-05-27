#!/bin/bash

echo '#'
echo '# Installing Couchbase'
echo '#'

CB_VERSION=3.0.1
CB_RELEASE_URL=http://packages.couchbase.com/releases
CB_PACKAGE=couchbase-server-community-3.0.1-centos6.x86_64.rpm
PATH=$PATH:/opt/couchbase/bin:/opt/couchbase/bin/tools:/opt/couchbase/bin/install
rpm --install $CB_RELEASE_URL/$CB_VERSION/$CB_PACKAGE

echo '#'
echo '# Waiting 7 seconds for the service to start'
echo '#'

sleep 7

echo '#'
echo '# Configuring Couchbase'
echo '#'

MYIPPRIVATE=$(curl http://169.254.169.254/latest/meta-data/local-ipv4)
MYIPPUBLIC=$(curl http://169.254.169.254/latest/meta-data/public-ipv4)
MYMEMORY=$(free -m | grep -o "Mem:\s*[0-9]*" | grep -o "[0-9]*")
MYMEMORY=$(echo "$MYMEMORY*.80" | bc | grep -o "^[^\.]*")

/opt/couchbase/bin/couchbase-cli node-init -c 127.0.0.1:8091 -u access -p password \
    --node-init-data-path=/opt/couchbase/var/lib/couchbase/data \
    --node-init-index-path=/opt/couchbase/var/lib/couchbase/data \
    --node-init-hostname=$MYIPPRIVATE

/opt/couchbase/bin/couchbase-cli cluster-init -c 127.0.0.1:8091 -u access -p password \
    --cluster-init-username=Administrator \
    --cluster-init-password=password \
    --cluster-init-port=8091 \
    --cluster-init-ramsize=$MYMEMORY

/opt/couchbase/bin/couchbase-cli bucket-create -c 127.0.01:8091 -u Administrator -p password \
   --bucket=benchmarks \
   --bucket-type=couchbase \
   --bucket-ramsize=$MYMEMORY \
   --bucket-replica=1

echo '#'
echo '# Installed and configured'
echo '#'
echo "# Couchbase dashboard: http://$MYIPPUBLIC:8091"
echo '# username=Administrator'
echo '# password=password'
echo '#'

echo "Couchbase is installed, http://$MYIPPUBLIC:8091" > ~/couchbaseinstalled.txt