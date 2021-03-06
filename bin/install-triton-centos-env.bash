
# Couchbase-related environment variables
export MYIPPRIVATE=$(ip addr show | grep  "scope site dynamic" | grep -o '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}')
export MYIPPUBLIC=$(ip addr show | grep "scope global dynamic" | grep -o '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}')
export MYMEMORY=$(free -m | grep -o "Mem:\s*[0-9]*" | grep -o "[0-9]*")
export MYCPUS=$(nproc)
export MYCPUS=$(($MYCPUS>12?$(($MYMEMORY/3072)):$MYCPUS))
export MYCPUS=$(($MYCPUS>1?$MYCPUS:1))
export COUCHBASE_NS_SERVER_VM_EXTRA_ARGS=$(printf '["+S", "%s"]' $MYCPUS)
export ERL_AFLAGS="+S $MYCPUS"
export GOMAXPROCS=$MYCPUS
export MEMCACHED_NUM_CPUS=$MYCPUS
export MYMEMORY=$((($MYMEMORY/10)*8))
export CB_VERSION=3.0.1
export CB_RELEASE_URL=http://packages.couchbase.com/releases
export CB_PACKAGE=couchbase-server-community-3.0.1-centos6.x86_64.rpm
export PATH=$PATH:/opt/couchbase/bin:/opt/couchbase/bin/tools:/opt/couchbase/bin/install
