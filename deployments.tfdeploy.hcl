# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

identity_token "aws" {
  audience = ["stacks-demo"]
}

deployment "demo" {
    inputs = {
        cluster_name        = "stacks-demo"
        kubernetes_version  = "1.29"
        region              = "eu-central-1"
        role_arn            = "arn:aws:iam::403410321276:role/tfc-role"
        identity_token_file = identity_token.aws.jwt_filename
    }
}
