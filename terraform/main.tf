# Main Terraform configuration for SecureBank Payment Application
# This file serves as the entry point and orchestrates all modules

terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

   #Configure backend for state management
 cloud { 
     # This will be configured per environment
     organization = "securebank-semedo"
     workspaces {
       name = "securebank-payment-infra-dev"
     }
   }

}

# Configure AWS Provider
provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project     = var.project_name
      Environment = var.environment
      ManagedBy   = "Terraform"
      Owner       = var.owner
    }
  }
}

# Data sources
data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# VPC Module
module "vpc" {
  source = "./modules/vpc"

  environment     = var.environment
  project_name    = var.project_name
  vpc_cidr        = var.vpc_cidr
  azs             = data.aws_availability_zones.available.names
  private_subnets = var.private_subnets
  public_subnets  = var.public_subnets
}

# Security Module
module "security" {
  source = "./modules/security"

  environment  = var.environment
  project_name = var.project_name
  vpc_id       = module.vpc.vpc_id
  vpc_cidr     = module.vpc.vpc_cidr_block
}

# DynamoDB Module
module "dynamodb" {
  source = "./modules/dynamodb"

  environment  = var.environment
  project_name = var.project_name
  table_name   = "${var.project_name}-${var.environment}"
}

# EC2 Module
module "ec2" {
  source = "./modules/ec2"

  environment           = var.environment
  project_name          = var.project_name
  instance_type         = var.instance_type
  ami_id                = data.aws_ami.amazon_linux_2.id
  subnet_id             = module.vpc.private_subnet_ids[0]
  security_groups       = [module.security.app_security_group_id]
  key_name              = var.key_name
  user_data             = file("${path.module}/scripts/user_data.sh")
  instance_profile_name = module.security.ec2_instance_profile_name
}
