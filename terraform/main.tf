# Provider Configuration
provider "aws" {
  region = "us-east-1"
}

# Create VPC
resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/16"
}

# Create Public Subnet
resource "aws_subnet" "public_subnet" {
  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1a"  # Specify the availability zone in us-east-1
}

# Create Private Subnet
resource "aws_subnet" "private_subnet" {
  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "us-east-1b"  # Specify the availability zone in us-east-1
}

# Create Security Group for EKS Cluster
resource "aws_security_group" "eks_cluster_sg" {
  vpc_id = aws_vpc.my_vpc.id

  # Define ingress and egress rules as needed
}

# Create Security Group for EKS Nodes
resource "aws_security_group" "eks_node_sg" {
  vpc_id = aws_vpc.my_vpc.id

  # Define ingress and egress rules as needed
}

# Provision EKS Cluster
resource "aws_eks_cluster" "eks_cluster" {
  name     = "my-eks-cluster"
  role_arn = "arn:aws:iam::905418076327:role/eks-service-role"

  vpc_config {
    subnet_ids = [aws_subnet.public_subnet.id, aws_subnet.private_subnet.id]
    security_group_ids = [aws_security_group.eks_cluster_sg.id]
  }

  # Add other EKS cluster configuration as needed
}
