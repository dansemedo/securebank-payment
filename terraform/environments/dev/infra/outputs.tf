# Root module outputs

output "vpc_id" {
  description = "VPC ID"
  value       = module.vpcs.vpc_id
}

output "vpc_cidr_block" {
  description = "VPC CIDR block"
  value       = module.vpcs.vpc_cidr_block
}

output "public_subnet_ids" {
  description = "Public subnet IDs"
  value       = module.vpcs.public_subnet_ids
}

output "private_subnet_ids" {
  description = "Private subnet IDs"
  value       = module.vpcs.private_subnet_ids
}

output "ec2_instance_id" {
  description = "EC2 instance ID"
  value       = module.ec2.instance_id
}

output "ec2_public_ip" {
  description = "EC2 instance public IP"
  value       = module.ec2.public_ip
}

output "ec2_private_ip" {
  description = "EC2 instance private IP"
  value       = module.ec2.private_ip
}

output "dynamodb_table_name" {
  description = "DynamoDB table name"
  value       = module.dynamodb.table_name
}

output "dynamodb_table_arn" {
  description = "DynamoDB table ARN"
  value       = module.dynamodb.table_arn
}

output "app_security_group_id" {
  description = "Application security group ID"
  value       = module.security.app_security_group_id
}

output "ec2_role_arn" {
  description = "EC2 IAM role ARN"
  value       = module.security.ec2_role_arn
}

output "application_url" {
  description = "Application URL"
  value       = "http://${module.ec2.public_ip}:5000"
}

output "ssh_command" {
  description = "SSH command to connect to the instance"
  value       = "ssh -i ~/.ssh/${var.key_name}.pem ubuntu@${module.ec2.public_ip}"
}
