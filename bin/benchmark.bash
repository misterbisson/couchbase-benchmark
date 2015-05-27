#!/bin/bash

/opt/couchbase/bin/cbworkloadgen -n 10.117.79.85:8091 -r .9 -i 100000 -s 100 --threads 10 -j