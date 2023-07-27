# Github linux IaC

terraform workflow files for use with the LE linux based pipelines

## Requirements

Each repo needs to have the following variables set
repository variables required - settings/actions/variables

- OSVARS = OS TYPE for benchmark
- Benchmark_type = Type of benchmark (CIS or STIG)

eg.

```shell
OSVARS RHEL9
BENCHMARK_TYPE CIS
```

## Overview

This is called by the repository workflow to pull in this content.
This enables us to manage the workflow and IAC centrally, enabling us to quickly change anything for improvements of issues with a certain region.

```mermaid
   graph TD;
    A[Benchmark Pipeline] -->|Starts the github workflow|B[Loads  the linux_benchmark_testing]
    B --> C[Imports variables set in repo]
    C --> D[STEP - Welcome Message]
    D --> E[Sends welcome if first PR and invite to discord]
    C --> F[STEP - Build testing pipeline]
    F --> G[Starts runner based on ubuntu latest]
    G --> H[Imports Variables for usage across workflow]
    H --> I[Git Clone in repo and source branch PR is requested from]
    I --> J[Git Clone this content for IaC portion of pipeline]
    J --> K[creates a local key to be used - Secret]
    K --> L[Runs terraform steps]
    L -->|terraform init|M[Initiates terraform]
    M -->|terraform validate|N[Validates config]
    N -->|terraform apply|O[Runs terraform and sets up host]
    O -->|sleep 60 seconds|P[If Debug variable set output ansible hosts]
    P --> Q[Runs ansible playbook] --> |terraform destroy|R[Destroys all the IaC config]
```

# Run locally

```shell
$ export benchmark_type="CIS"
$ export OSVAR="RHEL8"
$ export TF_VAR_repository="${OSVAR}-${benchmark_type}"
$ export TF_VAR_benchmark_type="${benchmark_type}"

$ terraform apply -var-file "github_vars.tfvars" -var-file "${OSVAR}.tfvars"
$ terraform destroy -var-file "github_vars.tfvars" -var-file "${OSVAR}.tfvars"
```
