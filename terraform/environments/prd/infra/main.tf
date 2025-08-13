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
       name = "securebank-payment-infra-prd"
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
module "vpcs" {
  source  = "app.terraform.io/securebank-semedo/vpcs/aws"
  version = "0.2.0"

  environment     = var.environment
  project_name    = var.project_name
  vpc_cidr        = var.vpc_cidr
  azs             = data.aws_availability_zones.available.names
  private_subnets = var.private_subnets
  public_subnets  = var.public_subnets
}

# Security Module
module "security" {
  source  = "app.terraform.io/securebank-semedo/security/aws"
  version = "0.3.0"

  environment  = var.environment
  project_name = var.project_name
  vpc_id       = module.vpcs.vpc_id
  vpc_cidr     = module.vpcs.vpc_cidr_block
}

# DynamoDB Module
module "dynamodb" {
  source  = "app.terraform.io/securebank-semedo/dynamodb/aws"
  version = "0.2.0"


  environment  = var.environment
  project_name = var.project_name
  table_name   = "${var.project_name}-${var.environment}"
}

# EC2 Module
module "ec2" {
  source  = "app.terraform.io/securebank-semedo/ec2/aws"
  version = "0.2.0"

  environment           = var.environment
  project_name          = var.project_name
  instance_type         = var.instance_type
  ami_id                = data.aws_ami.amazon_linux_2.id
  subnet_id             = module.vpcs.private_subnet_ids[0]
  security_groups       = [module.security.app_security_group_id]
  key_name              = var.key_name
  user_data             = file("${path.module}/scripts/user_data.sh")
  instance_profile_name = module.security.ec2_instance_profile_name
}
