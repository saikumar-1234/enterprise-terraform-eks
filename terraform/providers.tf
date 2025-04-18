
# terraform/providers.tf - Configure AWS provider

provider "aws" {
  region = var.region
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  # Backend for state management (S3 + DynamoDB)
  backend "s3" {
    bucket         = "<your-s3-bucket>"
    key            = "terraform/state"
    region         = "us-west-2"
    dynamodb_table = "<your-dynamodb-table>"
  }
}