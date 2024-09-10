# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

component "cluster" {
  source = "./cluster"

  inputs = {
    cluster_name       = var.cluster_name
    kubernetes_version = var.kubernetes_version
    region = var.region
  }

  providers = {
    aws = provider.aws.main
    random = provider.random.main
  }
}

component "kube" {
  source = "shernandez5/crd-demo-module/kubernetes"
  version = "0.1.0"

  providers = {
    kubernetes = provider.kubernetes.main
  }
}

component "unrelated-tfe-prov-example" {
  source = "git::https://github.com/shernandez5/terraforming-stacks.git"

  inputs = {
    tfe_organization  = var.tfe_organization
    tfe_project_name  = var.tfe_project_name
    github_username   = var.github_username
    oauth_client_name = var.oauth_client_name
    repo_name         = var.repo_name
  }
  
  providers = {
    tfe = provider.tfe.main
    random = provider.random.main
  }

}