# EC2 Module for SecureBank Payment Applications

# Create EC2 instance
resource "aws_instance" "app_server" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = var.security_groups
  key_name               = var.key_name
  user_data              = var.user_data
  iam_instance_profile   = var.instance_profile_name

  root_block_device {
    volume_size = 20
    volume_type = "gp3"
    encrypted   = true

    tags = {
      Name        = "${var.project_name}-root-volume-${var.environment}"
      Environment = var.environment
      Project     = var.project_name
    }
  }

  tags = {
    Name        = "${var.project_name}-app-server-${var.environment}"
    Environment = var.environment
    Project     = var.project_name
  }
}

# Create Elastic IP for the instance
resource "aws_eip" "app_eip" {
  domain   = "vpc"
  instance = aws_instance.app_server.id

  tags = {
    Name        = "${var.project_name}-app-eip-${var.environment}"
    Environment = var.environment
    Project     = var.project_name
  }
}
