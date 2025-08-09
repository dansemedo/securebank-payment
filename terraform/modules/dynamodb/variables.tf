# Variables for DynamoDB Module

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "table_name" {
  description = "Name of the DynamoDB table"
  type        = string
}
