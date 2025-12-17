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
    
    # Create the site HTML directly on the instance (embedded here so repo no longer needs site/ files)
    cat > /var/www/html/index.html <<'HTML'
  <!DOCTYPE html>
  <html lang="en">
  <head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Terraform Deployed Website</title>
    <style>
      * {
        margin: 0;
        padding: 0;
        box-sizing: border-box;
      }
      body {
        font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        min-height: 100vh;
        display: flex;
        align-items: center;
        justify-content: center;
        padding: 20px;
      }
      .container {
        background: rgba(255, 255, 255, 0.95);
        border-radius: 20px;
        padding: 60px 40px;
        max-width: 600px;
        box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
        text-align: center;
        animation: fadeIn 0.8s ease-in;
      }
      @keyframes fadeIn {
        from {
          opacity: 0;
          transform: translateY(-20px);
        }
        to {
          opacity: 1;
          transform: translateY(0);
        }
      }
      h1 {
        color: #667eea;
        font-size: 2.5em;
        margin-bottom: 20px;
        font-weight: 700;
      }
      .success-icon {
        font-size: 4em;
        margin-bottom: 20px;
        animation: bounce 1s ease infinite;
      }
      @keyframes bounce {
        0%, 100% { transform: translateY(0); }
        50% { transform: translateY(-10px); }
      }
      p {
        color: #555;
        font-size: 1.2em;
        line-height: 1.6;
        margin-bottom: 15px;
      }
      .info-box {
        background: #f0f4ff;
        border-left: 4px solid #667eea;
        padding: 20px;
        margin-top: 30px;
        border-radius: 8px;
        text-align: left;
      }
      .info-box h2 {
        color: #667eea;
        font-size: 1.3em;
        margin-bottom: 15px;
      }
      .info-box ul {
        list-style: none;
        padding-left: 0;
      }
      .info-box li {
        padding: 8px 0;
        color: #666;
        font-size: 1em;
      }
      .info-box li:before {
        content: "✓ ";
        color: #667eea;
        font-weight: bold;
        margin-right: 8px;
      }
      .badge {
        display: inline-block;
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        color: white;
        padding: 8px 20px;
        border-radius: 20px;
        font-size: 0.9em;
        margin-top: 20px;
        font-weight: 600;
      }
    </style>
  </head>
  <body>
    <div class="container">
      <div class="success-icon">🚀</div>
      <h1>Deployment Successful!</h1>
      <p>Your Terraform-managed EC2 instance is up and running.</p>
      <p>This website was automatically deployed via GitHub Actions.</p>
        
      <div class="info-box">
        <h2>Pipeline Features</h2>
        <ul>
          <li>Automated Terraform deployment</li>
          <li>GitHub Actions CI/CD integration</li>
          <li>Nginx web server configured</li>
          <li>Idempotent infrastructure as code</li>
          <li>Zero manual intervention required</li>
          <li>Automatic Content Updates 🔄</li>
        </ul>
      </div>
        
      <div class="badge">Powered by Terraform + GitHub Actions</div>
    </div>
  </body>
  </html>
HTML
    
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



