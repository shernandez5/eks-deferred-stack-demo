# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

identity_token "aws" {
  audience = ["aws.workload.identity"]
}

deployment "demo" {
    inputs = {
        cluster_name        = "stacks-demo"
        kubernetes_version  = "1.30"
        region              = "eu-central-1"
        role_arn            = "arn:aws:iam::225401527358:role/lambda-component-expansion-stack"
        identity_token = identity_token.aws.jwt
    }
}
