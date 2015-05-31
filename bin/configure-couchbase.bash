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
echo '# Testing to see if Couchbase is running yet'
echo '#'

COUCHBASERESPONSIVE=0
while [ $COUCHBASERESPONSIVE != 1 ]; do
    echo -n '.'
    sleep .7

    # test the default u/p
    couchbase-cli server-info -c 127.0.0.1:8091 -u access -p password &> /dev/null
    if [ $? -eq 0 ]; then
        let COUCHBASERESPONSIVE=1
    fi

    # test the alternate u/p
    couchbase-cli server-info -c 127.0.0.1:8091 -u Administrator -p password &> /dev/null
    if [ $? -eq 0 ]; then
        let COUCHBASERESPONSIVE=1
    fi
done

echo
echo '#'
echo '# Configuring Couchbase'
echo '#'

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
