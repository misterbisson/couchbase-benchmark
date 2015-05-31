#!/bin/bash

echo '#'
echo "# Installing Node.js..."
echo '#'
yum install -q -y gcc-c++ make unzip

# Node.js installation steps copied from https://github.com/joyent/docker-node/blob/428d5e69763aad1f2d8f17c883112850535e8290/0.12/Dockerfile

gpg --keyserver pool.sks-keyservers.net --recv-keys 7937DFD2AB06298B2293C3187D33FF9D0246406D 114F43EE0176B71C7BC219DD50A3051F888C628D

NODE_VERSION=0.12.4
NPM_VERSION=2.10.1
PATH="$PATH:/usr/local/bin"

curl -SLO "http://nodejs.org/dist/v$NODE_VERSION/node-v$NODE_VERSION-linux-x64.tar.gz" \
	&& curl -SLO "http://nodejs.org/dist/v$NODE_VERSION/SHASUMS256.txt.asc" \
	&& gpg --verify SHASUMS256.txt.asc \
	&& grep " node-v$NODE_VERSION-linux-x64.tar.gz\$" SHASUMS256.txt.asc | sha256sum -c - \
	&& tar -xzf "node-v$NODE_VERSION-linux-x64.tar.gz" -C /usr/local --strip-components=1 \
	&& rm -f "node-v$NODE_VERSION-linux-x64.tar.gz" SHASUMS256.txt.asc \
	&& npm install -g npm@"$NPM_VERSION" \
	&& npm cache clear

npm install -g cb-cloud-benchmark --unsafe-perm

echo '#'
echo "# Getting source data..."
echo '#'
rm -Rf cb-cloud-benchmark-data-*
curl -o data.zip -L https://github.com/corbinu/cb-cloud-benchmark-data/archive/79bd88b76cbf9cbec987d84f1ef6ad996973d526.zip
unzip data.zip

echo '#'
echo "# Uncompressing source data..."
echo '#'
cd cb-cloud-benchmark-data-* && ./expand.sh

echo '#'
echo "# Setting up views..."
echo '#'
cloud-benchmark setup -c couchbase://127.0.0.1

echo '#'
echo "# Executing benchmarks..."
echo '#'
echo '# If this fails, retry with:'
echo "# cloud-benchmark run -d $(pwd) -c couchbase://127.0.0.1"
echo '#'
cloud-benchmark run -d . -c couchbase://127.0.0.1
