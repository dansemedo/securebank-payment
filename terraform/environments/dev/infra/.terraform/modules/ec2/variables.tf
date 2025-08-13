# Variables for EC2 Module

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

variable "ami_id" {
  description = "AMI ID for the EC2 instance"
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID where the EC2 instance will be launched"
  type        = string
}

variable "security_groups" {
  description = "List of security group IDs"
  type        = list(string)
}

variable "key_name" {
  description = "Name of the EC2 key pair"
  type        = string
}

variable "user_data" {
  description = "User data script for the EC2 instance"
  type        = string
}

variable "instance_profile_name" {
  description = "Name of the IAM instance profile"
  type        = string
}
