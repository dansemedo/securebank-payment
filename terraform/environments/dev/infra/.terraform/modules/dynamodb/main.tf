# DynamoDB Module for SecureBank Payment Application

# Create DynamoDB table
resource "aws_dynamodb_table" "main" {
  name         = var.table_name
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "id"
  range_key    = "timestamp"

  attribute {
    name = "id"
    type = "S"
  }

  attribute {
    name = "timestamp"
    type = "S"
  }

  # Point-in-time recovery
  point_in_time_recovery {
    enabled = true
  }

  # Server-side encryption
  server_side_encryption {
    enabled = true
  }

  tags = {
    Name        = "${var.project_name}-dynamodb-${var.environment}"
    Environment = var.environment
    Project     = var.project_name
  }
}
