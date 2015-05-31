#!/bin/bash

MYMEMORY=$1
BUCKET=$2
MYIPPRIVATE=$3
MYIPPUBLIC=$4

installed ()
{
    echo '#'
    echo '# Couchbase is installed and configured'
    echo '#'
    echo "# Dashboard: http://$MYIPPUBLIC:8091"
    echo "# Internal IP: $MYIPPRIVATE"
    echo "# Bucket: $BUCKET"
    echo '# username=Administrator'
    echo '# password=password'
    echo '#'
}

if [ "$(couchbase-cli bucket-list -c 127.0.0.1:8091 -u Administrator -p password | grep ^$BUCKET)" == $BUCKET ]; then
    installed
    exit
fi

echo
echo '#'
echo '# Configuring Couchbase'
echo '#'

#couchbase-cli server-list -c 127.0.0.1:8091 -u Administrator -p password

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
   --bucket=$BUCKET \
   --bucket-type=couchbase \
   --bucket-ramsize=$MYMEMORY \
   --bucket-replica=1

installed
