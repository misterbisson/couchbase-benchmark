# Couchbase Benchmarks

Install and benchmark Couchbase on various infrastructure providers.

See details for how to execute on various providers below. I'm told the most common AWS instance type is `r3`, so the default resource size is based on `r3.large` and near approximations to it.

### Usage

Different infrastructures will likely exhibit different performance characteristics and often have specific installation requirements. Detailed guides are provided for the following:

1. [Joyent Triton infrastructure container](./docs/triton-container.md)
1. [AWS virtual machine](./docs/aws-vm.md)
1. [Generic instructions](./docs/generic-unk.md)