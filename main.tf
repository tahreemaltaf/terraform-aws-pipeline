# Data source to get default VPC
data "aws_vpc" "default" {
  default = true
}

# Random ID for unique resource naming
resource "random_id" "suffix" {
  byte_length = 4
}

# Security Group for Web Server
resource "aws_security_group" "web_server_sg" {
  name        = "${var.project_name}-web-sg-${random_id.suffix.hex}"
  description = "Security group for web server allowing HTTP, HTTPS, and SSH"
  vpc_id      = data.aws_vpc.default.id

  # HTTP access from anywhere
  ingress {
    description = "HTTP from anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTPS access from anywhere
  ingress {
    description = "HTTPS from anywhere"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # SSH access (configurable)
  ingress {
    description = "SSH access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.ssh_cidr_blocks
  }

  # Allow all outbound traffic
  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.project_name}-web-sg"
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

# Generate SSH Key Pair
resource "tls_private_key" "deploy_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "deployer" {
  key_name   = "${var.project_name}-deploy-key-${random_id.suffix.hex}"
  public_key = tls_private_key.deploy_key.public_key_openssh
}

# User data script to install and configure Nginx
locals {
  user_data = <<-EOF
    #!/bin/bash
    set -e
    
    # Update system packages
    apt-get update -y
    
    # Install Nginx
    apt-get install -y nginx
    
    # Start and enable Nginx
    systemctl start nginx
    systemctl enable nginx
    
    # Set proper permissions for ubuntu user to modify web content
    chown -R ubuntu:ubuntu /var/www/html
    chmod -R 755 /var/www/html
    
    # Create a placeholder page until CD pipeline runs
    echo "<h1>Initializing...</h1><p>Please wait for the GitHub Action to deploy the website content.</p>" > /var/www/html/index.html
    
    echo "Web server setup completed successfully!"
  EOF
}

# EC2 Instance
resource "aws_instance" "web_server" {
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = aws_key_pair.deployer.key_name

  vpc_security_group_ids = [aws_security_group.web_server_sg.id]

  user_data = local.user_data

  # Enable public IP
  associate_public_ip_address = true

  # Root volume configuration
  root_block_device {
    volume_size           = 8
    volume_type           = "gp3"
    encrypted             = true
    delete_on_termination = true
  }

  tags = {
    Name        = "${var.project_name}-instance"
    Environment = var.environment
    ManagedBy   = "Terraform"
    Purpose     = "Web Server"
  }

  # Ensure instance is replaced if user data changes
  user_data_replace_on_change = true
}



