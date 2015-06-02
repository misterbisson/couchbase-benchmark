#!/bin/bash

# Couchbase-related environment variables
MYIPPRIVATE=$(ip addr show eth0 | grep -o '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}')
MYIPPUBLIC=MYIPPRIVATE
MYMEMORY=$(free -m | grep -o "Mem:\s*[0-9]*" | grep -o "[0-9]*")
MYMEMORY=$(echo "$MYMEMORY*.80" | bc | grep -o "^[^\.]*")

PATH=$PATH:/opt/couchbase/bin:/opt/couchbase/bin/tools:/opt/couchbase/bin/install

# install couchbase if it hasn't already been installed
if [ ! -d "/opt/couchbase/" ]; then
    echo '#'
    echo '# Installing Couchbase'
    echo '#'

    CB_VERSION=3.0.1
    CB_RELEASE_URL=http://packages.couchbase.com/releases
    CB_PACKAGE=couchbase-server-community-3.0.1-centos6.x86_64.rpm
    rpm --install $CB_RELEASE_URL/$CB_VERSION/$CB_PACKAGE

    sleep 3
fi

echo '#'
echo '# Waiting for Couchbase to start'
echo '#'
while [ ! -f "/opt/couchbase/var/lib/couchbase/couchbase-server.pid" ]; do
    echo -n '.'
    sleep 1.3
done
sleep 2

# configure Couchbase
curl -sL https://raw.githubusercontent.com/misterbisson/couchbase-benchmark/master/bin/configure-couchbase.bash | bash -s $MYMEMORY benchmark $MYIPPRIVATE $MYIPPUBLIC

echo "Couchbase is installed, http://$MYIPPUBLIC:8091" > /root/couchbase.txt
