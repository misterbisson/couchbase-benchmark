#!/bin/bash

# "I would turn ‘set -o xtrace’, and reopen stderr to a log file"

# Be sure to have the environment vars set. It's a step in the instructions, or you can do:
# source <(curl -s https://raw.githubusercontent.com/misterbisson/couchbase-benchmark/master/bin/install-triton-centos-env.bash)

echo '#'
echo '# Installing Couchbase'
echo '#'

CB_VERSION=3.0.1
CB_RELEASE_URL=http://packages.couchbase.com/releases
CB_PACKAGE=couchbase-server-community-3.0.1-centos6.x86_64.rpm
rpm --install $CB_RELEASE_URL/$CB_VERSION/$CB_PACKAGE

# sleep just a moment to let the installation settle
sleep 1

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
   --bucket=default \
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
