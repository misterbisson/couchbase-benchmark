#!/bin/bash

# "I would turn ‘set -o xtrace’, and reopen stderr to a log file"

# Set the environment vars and add them to the bash_profile for next time
echo -e "$(curl -s https://raw.githubusercontent.com/misterbisson/couchbase-benchmark/master/bin/install-triton-centos-env.bash)" >> /root/.bash_profile && source /root/.bash_profile

# We could also set the environment vars by
# source <(curl -s https://raw.githubusercontent.com/misterbisson/couchbase-benchmark/master/bin/install-triton-centos-env.bash)

# install couchbase if it hasn't already been installed
if [ ! -d "/opt/couchbase/" ]; then
    echo '#'
    echo '# Installing Couchbase'
    echo '#'

    rpm --install $CB_RELEASE_URL/$CB_VERSION/$CB_PACKAGE

    echo '#'
    echo '# Waiting 13 seconds for the service to start'
    echo '#'

    sleep 13
fi

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
