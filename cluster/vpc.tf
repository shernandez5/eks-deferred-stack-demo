# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

data "aws_region" "current" {
}

data "aws_availability_zones" "available" {
  state = "available"
}

locals {
  tagName = "hcp-terraform-eks-demo-node"
  eks_azs = [for az in data.aws_availability_zones.available.names : az if az != "us-east-1e"]
  azCount = length(local.eks_azs)
}

resource "aws_vpc" "demo" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    "Name"                                      = local.tagName
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
  }
}

resource "aws_subnet" "demo" {
  count = local.azCount

  availability_zone       = local.eks_azs[count.index]
  cidr_block              = "10.0.${count.index}.0/24"
  vpc_id                  = aws_vpc.demo.id
  map_public_ip_on_launch = true

  tags = {
    "Name"                                      = local.tagName
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/elb"                    = 1
  }
}

resource "aws_internet_gateway" "demo" {
  vpc_id = aws_vpc.demo.id

  tags = {
    Name = local.tagName
  }
}

resource "aws_route_table" "demo" {
  vpc_id = aws_vpc.demo.id

  tags = {
    Name = local.tagName
  }

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.demo.id
  }
}

resource "aws_route_table_association" "demo" {
  count = 2

  subnet_id      = aws_subnet.demo[count.index].id
  route_table_id = aws_route_table.demo.id
}

