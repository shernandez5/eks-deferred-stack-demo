# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.59.0"
    }
    random = {
      source = "hashicorp/random"
      version = "~> 3.6.2"
    }
  }
}

resource "random_string" "demo" {
  length = 4
  special = false
  upper = false
}

locals {
  cluster_name = "${var.cluster_name}-${random_string.demo.result}"
}

resource "aws_eks_cluster" "demo" {
  name     = local.cluster_name
  version  = var.kubernetes_version
  role_arn = aws_iam_role.demo-cluster.arn

  vpc_config {
    subnet_ids = aws_subnet.demo.*.id
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Cluster handling.
  # Otherwise, EKS will not be able to properly delete EKS managed EC2 infrastructure such as Security Groups.
  depends_on = [
    aws_iam_role_policy_attachment.demo-AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.demo-AmazonEKSVPCResourceController,
  ]
}

resource "aws_eks_node_group" "demo" {
  cluster_name    = aws_eks_cluster.demo.name
  node_group_name = "${local.cluster_name}-default"
  node_role_arn   = aws_iam_role.demo-node.arn
  subnet_ids      = aws_subnet.demo.*.id

  scaling_config {
    desired_size = var.workers_count
    max_size     = local.azCount
    min_size     = 1
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
  # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
  depends_on = [
    aws_iam_role_policy_attachment.demo-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.demo-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.demo-AmazonEC2ContainerRegistryReadOnly,
  ]
}

data "aws_eks_cluster_auth" "demo" {
  name = aws_eks_cluster.demo.name
}
