provider "aws" {
  region = var.aws_region
}

# Create a VPC
resource "aws_vpc" "test_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "msk_pl_test_vpc"
  }
}

# Create subnets
resource "aws_subnet" "test_subnet" {
  count                   = length(var.subnet_cidrs)
  vpc_id                  = aws_vpc.test_vpc.id
  cidr_block              = var.subnet_cidrs[count.index]
  availability_zone       = element(var.availability_zones, count.index)
  map_public_ip_on_launch = true
  tags = {
    Name = "testsubnet-${count.index}"
  }
}

# MSK Cluster setup
resource "aws_msk_cluster" "test_msk_cluster" {
  cluster_name      = "pl-test-msk-cluster"
  kafka_version     = "3.4.0"
  number_of_broker_nodes = 2

  broker_node_group_info {
    instance_type   = "kafka.t3.small"
    client_subnets  = aws_subnet.test_subnet[*].id
    security_groups = [aws_security_group.msk_sg.id]
  }

  encryption_info {
    encryption_in_transit {
      client_broker = "PLAINTEXT"
    }
  }

  tags = {
    Name = "TestMSKCluster"
  }
}

# Security group for MSK
resource "aws_security_group" "msk_sg" {
  name        = "msk-sg-test"
  description = "Security group for MSK cluster test"
  vpc_id      = aws_vpc.test_vpc.id

  # Allow all outbound
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 9092
    to_port     = 9092
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.test_vpc.cidr_block]
  }

  tags = {
    Name = "msk-security-group-test"
  }
}
