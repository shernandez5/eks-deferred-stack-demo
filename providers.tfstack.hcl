required_providers {
  aws = {
    source  = "hashicorp/aws"
    version = "~> 5.59.0"
  }
  kubernetes = {
    source  = "hashicorp/kubernetes"
    version = "~> 2.31.0"
  }
  random = {
    source = "hashicorp/random"
    version = "~> 3.6.2"
  }
}

provider "aws" "main" {
    config {
        region = var.region
        assume_role_with_web_identity {
            role_arn                = var.role_arn
            web_identity_token_file = var.identity_token_file
        }
    }
}

provider "kubernetes" "main" {
  config {
    host                   = component.cluster.cluster_url
    cluster_ca_certificate = component.cluster.cluster_ca
    token                  = component.cluster.cluster_token
  }
}

provider "random" "main" {}