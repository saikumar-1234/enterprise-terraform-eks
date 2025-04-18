
# terraform/main.tf - Root module to orchestrate infrastructure deployment

# Initialize Terraform workspace for environment-specific state management
resource "null_resource" "set_workspace" {
  provisioner "local-exec" {
    command = "terraform workspace select ${var.environment} || terraform workspace new ${var.environment}"
  }
}

# VPC module to create networking resources
module "vpc" {
  source = "./modules/vpc"

  environment = var.environment
  vpc_cidr    = var.vpc_cidr
  region      = var.region
}

# IAM module to create EKS roles and policies
module "iam" {
  source = "./modules/iam"

  environment = var.environment
}

# EKS module to create the Kubernetes cluster
module "eks" {
  source = "./modules/eks"

  environment     = var.environment
  vpc_id          = module.vpc.vpc_id
  private_subnets = module.vpc.private_subnets
  cluster_role_arn = module.iam.eks_cluster_role_arn
  node_role_arn   = module.iam.eks_node_role_arn
}