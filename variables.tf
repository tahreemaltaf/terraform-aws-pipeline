# AWS Region variable
variable "aws_region" {
  description = "AWS region for resources"
  type        = string
  default     = "ap-south-1"
}

# EC2 Instance type variable
variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"  # Free tier eligible in ap-south-1
}

# AMI ID variable (Ubuntu 22.04 LTS for ap-south-1)
variable "ami_id" {
  description = "AMI ID for EC2 instance"
  type        = string
  default     = "ami-0f5ee92e2d63afc18" # Ubuntu 22.04 LTS in ap-south-1
}

# SSH Key Pair Name (optional)
variable "key_name" {
  description = "SSH key pair name for EC2 access (leave empty if not using SSH keys)"
  type        = string
  default     = ""
}

# Allowed SSH CIDR blocks
variable "ssh_cidr_blocks" {
  description = "CIDR blocks allowed to SSH into the instance"
  type        = list(string)
  default     = ["0.0.0.0/0"] # WARNING: Open to all - restrict in production
}

# Environment tag
variable "environment" {
  description = "Environment name"
  type        = string
  default     = "development"
}

# Project name
variable "project_name" {
  description = "Project name for resource tagging"
  type        = string
  default     = "terraform-web-server"
}
