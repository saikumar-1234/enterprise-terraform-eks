# terraform/modules/eks/main.tf - EKS cluster and node group

# EKS cluster
resource "aws_eks_cluster" "main" {
  name     = "${var.environment}-eks-clusterr"
  role_arn = var.cluster_role_arn

  vpc_config {
    subnet_ids = var.private_subnets
    endpoint_public_access = false # Private endpoint for security
  }

  tags = {
    Environment = var.environment
  }
}

# EKS node group
resource "aws_eks_node_group" "main" {
  cluster_name    = aws_eks_cluster.main.name
  node_group_name = "${var.environment}-node-group"
  node_role_arn   = var.node_role_arn
  subnet_ids      = var.private_subnets

  scaling_config {
    desired_size = 2
    max_size     = 3
    min_size     = 1
  }

  instance_types = ["t3.medium"]

  tags = {
    Environment = var.environment
  }
}