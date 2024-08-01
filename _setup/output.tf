# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

output "aws_oidc_role" {
  value = aws_iam_role.tfc_role.arn
}

output "stack_name" {
  value = tfe_stack.demo.name
}