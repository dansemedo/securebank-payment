terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  cloud { 
    
    organization = "securebank-semedo" 

    workspaces { 
      name = "securebank-payment-infra-dev" 
    } 
  } 
}

provider "aws" {
  region = "us-east-1"
}

module "securebank_payment" {
  source = "../../../"

  environment   = "dev"
  instance_type = "t2.nano"
  key_name      = "securebank-key-dev"
}
