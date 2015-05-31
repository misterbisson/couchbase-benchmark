#!/bin/bash

# "I would turn ‘set -o xtrace’, and reopen stderr to a log file"
# this script is run via /bin/bash /var/svc/mdata-user-script on startup, when called as a userscript during machine provisioning

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

curl -s https://raw.githubusercontent.com/misterbisson/couchbase-benchmark/master/bin/configure-couchbase.bash | bash -s $MYMEMORY $MYIPPRIVATE $MYIPPUBLIC
