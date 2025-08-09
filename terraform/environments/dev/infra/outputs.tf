# Development environment outputs
output "vpc_id" {
  description = "VPC ID"
  value       = module.securebank_payment.vpc_id
}

output "public_subnet_ids" {
  description = "Public subnet IDs"
  value       = module.securebank_payment.public_subnet_ids
}

output "private_subnet_ids" {
  description = "Private subnet IDs"
  value       = module.securebank_payment.private_subnet_ids
}

output "ec2_instance_id" {
  description = "EC2 instance ID"
  value       = module.securebank_payment.ec2_instance_id
}

output "ec2_public_ip" {
  description = "EC2 instance public IP"
  value       = module.securebank_payment.ec2_public_ip
}

output "application_url" {
  description = "Application URL"
  value       = "http://${module.securebank_payment.ec2_public_ip}:5000"
}

output "dynamodb_table_name" {
  description = "DynamoDB table name"
  value       = module.securebank_payment.dynamodb_table_name
}

output "ssh_command" {
  description = "SSH command to connect to the instance"
  value       = "ssh -i ~/.ssh/securebank-key-dev.pem ubuntu@${module.securebank_payment.ec2_public_ip}"
}
