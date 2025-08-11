# Development environment specific variables
variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

variable "instance_type" {
  description = "EC2 instance type for development"
  type        = string
  default     = "t2.small"
}

variable "key_name" {
  description = "EC2 key pair name for development"
  type        = string
  default     = "securebank-key-dev"
}

variable "dynamodb_billing_mode" {
  description = "DynamoDB billing mode for development"
  type        = string
  default     = "PAY_PER_REQUEST"
}
