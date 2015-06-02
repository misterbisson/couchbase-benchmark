#!/bin/bash

# "I would turn ‘set -o xtrace’, and reopen stderr to a log file"
# this script is run via /bin/bash /var/svc/mdata-user-script on startup, when called as a userscript during machine provisioning

# Set the environment vars and add them to the bash_profile for next time
echo -e "$(curl -s https://raw.githubusercontent.com/misterbisson/couchbase-benchmark/master/bin/install-triton-centos-env.bash)" >> /root/.bash_profile && source /root/.bash_profile

# We could also set the environment vars by
# source <(curl -s https://raw.githubusercontent.com/misterbisson/couchbase-benchmark/master/bin/install-triton-centos-env.bash)

# install Couchbase if it hasn't already been installed
if [ ! -d "/opt/couchbase/" ]; then
    echo '#'
    echo '# Installing Couchbase'
    echo '#'

    rpm --install $CB_RELEASE_URL/$CB_VERSION/$CB_PACKAGE

    sleep 3
fi

if grep -Fxq 'CPU limits to keep Couchbase from trying to schedule across all the CPUs' /opt/couchbase/bin/couchbase-server
then
    echo '#'
    echo '# Setting CPU limits for Couchbase and restarting'
    echo '#'

    # insert Triton-specific config details into the startup script
    cat /opt/couchbase/bin/couchbase-server | \
    sed "/export PATH/a export ERL_AFLAGS" | \
    sed "/export PATH/a ERL_AFLAGS='+S $MYCPUS'" | \
    sed "/export PATH/a export COUCHBASE_NS_SERVER_VM_EXTRA_ARGS" | \
    sed "/export PATH/a COUCHBASE_NS_SERVER_VM_EXTRA_ARGS=$(printf '["+S", "%s"]' $MYCPUS)" | \
    sed "/export PATH/a \# CPU limits to keep Couchbase from trying to schedule across all the CPUs it can see" | \
    sed '/export PATH/a
    ' \
    > /root/couchbase-server-config.tmp

    # copy the temp back to the primary and delete the temp
    cat /root/couchbase-server-config.tmp > /opt/couchbase/bin/couchbase-server
    rm -f /root/couchbase-server-config.tmp

    # restart Couchbase
    /etc/init.d/couchbase-server restart
fi

echo '#'
echo '# Waiting for Couchbase to start'
echo '#'

COUCHBASERESPONSIVE=0
while [ $COUCHBASERESPONSIVE != 1 ]; do
    echo -n '.'

    # test the default u/p
    couchbase-cli server-info -c 127.0.0.1:8091 -u access -p password &> /dev/null
    if [ $? -eq 0 ]; then
        let COUCHBASERESPONSIVE=1
    fi

    # test the alternate u/p
    couchbase-cli server-info -c 127.0.0.1:8091 -u Administrator -p password &> /dev/null
    if [ $? -eq 0 ]; then
        let COUCHBASERESPONSIVE=1
        sleep .7
    fi
done
sleep 2

# set the number of writers
/opt/couchbase/bin/cbepctl 127.0.0.1:11210 -b default set flush_param max_num_writers $(($MYCPUS>1?$MYCPUS/2:1))

# configure Couchbase
curl -sL https://raw.githubusercontent.com/misterbisson/couchbase-benchmark/master/bin/configure-couchbase.bash | bash -s $MYMEMORY benchmark $MYIPPRIVATE $MYIPPUBLIC

echo "Couchbase is installed, http://$MYIPPUBLIC:8091" > /root/couchbase.txt
