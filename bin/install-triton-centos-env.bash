
# Couchbase-related environment variables
export MYIPPRIVATE=$(ip addr show eth0 | grep -o '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}')
export MYIPPUBLIC=$(ip addr show eth1 | grep -o '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}')
export MYMEMORY=$(free -m | grep -o "Mem:\s*[0-9]*" | grep -o "[0-9]*")
export MYCPUS=$(nproc)
export MYCPUS=$(($MYCPUS>12?$(($MYMEMORY/2048)):$MYCPUS))
export MYCPUS=$(($MYCPUS>1?$MYCPUS:1))
export COUCHBASE_NS_SERVER_VM_EXTRA_ARGS=$(printf '["+S", "%s"]' $MYCPUS)
export ERL_AFLAGS="+S $MYCPUS"
export MYMEMORY=$(echo "$MYMEMORY*.80" | bc | grep -o "^[^\.]*")
export PATH=$PATH:/opt/couchbase/bin:/opt/couchbase/bin/tools:/opt/couchbase/bin/install