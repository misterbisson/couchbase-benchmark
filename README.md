# Couchbase Benchmarks

Install and benchmark Couchbase on various infrastructure providers.

See details for how to execute on various providers below. The default resource size is selected by price, with a goal to hit $0.120/hour or less. This typically selects for containers with about 4GB of RAM, though the number of CPUs varies. Feel free to change and test different resource sizes.

### Usage

Different infrastructures will likely exhibit different performance characteristics and often have specific installation requirements. Detailed guides are provided for the following:

1. [Joyent Triton infrastructure container](./docs/triton-container.md)
1. [AWS virtual machine](./docs/aws-vm.md)
1. [Generic instructions](./docs/generic-unk.md)