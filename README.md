# Example Stack for Kubernetes - EKS
This example demonstates an HCP Terraform Stack that creates an EKS cluster together with Kubernetes resources. 
It leverages deferred actions to enable users to create all the resources in the correct order using a single deployment action.

## Prerequisites

* Valid AWS credentials configured in the local environment (eg. via `doormat export`).
* An agent pool in your TFC org with at least one agent running with support for Stacks and deferred actions.

## How to use:

1. Apply the `_setup` module from your local environment. This does two things:
    * Creates the ODIC IDP configuration in AWS which enables TFC workload identity authentication from Stacks.
    * Creates the Stack itself in TFC. It doesn't configure it for the custom agent pool mentioned above due to limitations in the TFE provider. 
      
      *Make sure to manually configure the Stack to use the agent pool.*

2. Fetch configuration in the Stack UI to trigger the plan / apply cycle.
