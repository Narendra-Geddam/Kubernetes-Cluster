terraform {
  required_version = ">= 1.14.3"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
  }
}

locals {
  # Workers are pinned across two distinct AZ-backed subnets for HA.
  worker_subnet_ids = [
    aws_subnet.dev_test_cluster.id,
    aws_subnet.production_cluster.id
  ]

  # Control plane subnet is randomized per cluster between the two subnets.
  control_plane_subnet_by_cluster = {
    devtest    = local.worker_subnet_ids[random_integer.control_plane_subnet_index["devtest"].result]
    production = local.worker_subnet_ids[random_integer.control_plane_subnet_index["production"].result]
  }

  cluster_nodes = {
    devtest_control_plane = {
      cluster       = "Dev/Test Cluster"
      name          = "Dev/Test Cluster - Control Plane Node"
      role          = "Control Plane Node"
      instance_type = var.control_plane_instance_type
      subnet_id     = local.control_plane_subnet_by_cluster.devtest
    }
    devtest_worker_1 = {
      cluster       = "Dev/Test Cluster"
      name          = "Dev/Test Cluster - Worker Node 1"
      role          = "Worker Node 1"
      instance_type = var.worker_instance_type
      subnet_id     = local.worker_subnet_ids[0]
    }
    devtest_worker_2 = {
      cluster       = "Dev/Test Cluster"
      name          = "Dev/Test Cluster - Worker Node 2"
      role          = "Worker Node 2"
      instance_type = var.worker_instance_type
      subnet_id     = local.worker_subnet_ids[1]
    }
    production_control_plane = {
      cluster       = "Production Cluster"
      name          = "Production Cluster - Control Plane Node"
      role          = "Control Plane Node"
      instance_type = var.control_plane_instance_type
      subnet_id     = local.control_plane_subnet_by_cluster.production
    }
    production_worker_1 = {
      cluster       = "Production Cluster"
      name          = "Production Cluster - Worker Node 1"
      role          = "Worker Node 1"
      instance_type = var.worker_instance_type
      subnet_id     = local.worker_subnet_ids[0]
    }
    production_worker_2 = {
      cluster       = "Production Cluster"
      name          = "Production Cluster - Worker Node 2"
      role          = "Worker Node 2"
      instance_type = var.worker_instance_type
      subnet_id     = local.worker_subnet_ids[1]
    }
  }
}

# Read available AZs to place Dev/Test and Production in separate zones.
data "aws_availability_zones" "available" {
  state = "available"
}

# Randomize control plane placement per cluster across the two worker AZs.
resource "random_integer" "control_plane_subnet_index" {
  for_each = toset(["devtest", "production"])
  min      = 0
  max      = 1
}

# Resolve the latest Amazon Linux 2023 AMI for all cluster nodes.
data "aws_ami" "amazon_linux_2023" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# Base network for both clusters.
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "AWS VPC"
  }
}

# Internet access for public subnets/nodes.
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "VPC Internet Gateway"
  }
}

# Shared subnet A (AZ 1).
resource "aws_subnet" "dev_test_cluster" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.devtest_subnet_cidr
  availability_zone       = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = true

  tags = {
    Name = "Dev/Test Cluster Subnet"
  }
}

# Shared subnet B (AZ 2).
resource "aws_subnet" "production_cluster" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.production_subnet_cidr
  availability_zone       = data.aws_availability_zones.available.names[1]
  map_public_ip_on_launch = true

  tags = {
    Name = "Production Cluster Subnet"
  }
}

# Route table for public internet connectivity.
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "Public Route Table"
  }
}

resource "aws_route_table_association" "dev_test_cluster" {
  subnet_id      = aws_subnet.dev_test_cluster.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "production_cluster" {
  subnet_id      = aws_subnet.production_cluster.id
  route_table_id = aws_route_table.public.id
}

# Shared SG for both clusters (SSH + internal node communication).
resource "aws_security_group" "cluster_nodes" {
  name        = "cluster-nodes-sg"
  description = "Allow SSH and intra-cluster traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.ssh_cidr]
  }

  ingress {
    description = "All traffic within cluster SG"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    self        = true
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Cluster Nodes Security Group"
  }
}

resource "aws_instance" "cluster_nodes" {
  for_each               = local.cluster_nodes
  ami                    = data.aws_ami.amazon_linux_2023.id
  instance_type          = each.value.instance_type
  subnet_id              = each.value.subnet_id
  vpc_security_group_ids = [aws_security_group.cluster_nodes.id]
  key_name               = var.key_name

  tags = {
    Name    = each.value.name
    Cluster = each.value.cluster
    Role    = each.value.role
  }
}
