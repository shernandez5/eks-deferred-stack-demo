# Example Stack for Kubernetes - EKS
This example demonstates an HCP Terraform Stack that creates an EKS cluster together with Kubernetes resources. 
It leverages deferred changes to enable you to create all the resources in the correct order using a single Terraform configuration.

## Usage:

1. **Configure AWS authentication** by creating a new IAM role in the AWS web console (or with Terraform itself using our [quick start module](https://github.com/hashicorp-guides/terraform-stacks-identity-tokens)) with proper permissions and a trust policy to allow the role to be assumed by HCP Terraform (the OIDC identity provider). More details on this step can be found in the Stacks User Guide.
2. **Fork this repository** to your own GitHub or GitLab account, such that you can edit this stack configuration for your purposes.
3. **Edit your forked stack configuration** and change `deployments.tfdeploy.hcl` to use the ARNs of the IAM roles you created, as well as an audience value(s) for OpenID Connect.
4. **Create a new stack** in Terraform Cloud and connect it to your forked configuration repository.
5. **Provision away!** 
