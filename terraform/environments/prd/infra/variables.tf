# Production environment specific variables
variable "environment" {
  description = "Environment name"
  type        = string
  default     = "prd"
}

variable "instance_type" {
  description = "EC2 instance type for production"
  type        = string
  default     = "t2.small"
}

variable "key_name" {
  description = "EC2 key pair name for production"
  type        = string
  default     = "securebank-key-prd"
}

variable "dynamodb_billing_mode" {
  description = "DynamoDB billing mode for production"
  type        = string
  default     = "PROVISIONED"
}
