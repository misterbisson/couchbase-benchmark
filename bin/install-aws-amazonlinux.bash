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
echo '# Waiting 13 seconds for the service to start'
echo '#'

sleep 13

echo '#'
echo '# Configuring Couchbase'
echo '#'

MYIPPRIVATE=$(curl http://169.254.169.254/latest/meta-data/local-ipv4)
MYIPPUBLIC=$(curl http://169.254.169.254/latest/meta-data/public-ipv4)
MYMEMORY=$(free -m | grep -o "Mem:\s*[0-9]*" | grep -o "[0-9]*")
MYMEMORY=$(echo "$MYMEMORY*.80" | bc | grep -o "^[^\.]*")

curl -s https://raw.githubusercontent.com/misterbisson/couchbase-benchmark/master/bin/configure-couchbase.bash | bash -s $MYMEMORY benchmark $MYIPPRIVATE $MYIPPUBLIC

echo "Couchbase is installed, http://$MYIPPUBLIC:8091" > ~/couchbase.txt
