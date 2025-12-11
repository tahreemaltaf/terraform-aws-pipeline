# Output the public IP address
output "instance_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.web_server.public_ip
}

# Output the public DNS
output "instance_public_dns" {
  description = "Public DNS name of the EC2 instance"
  value       = aws_instance.web_server.public_dns
}

# Output the website URL
output "website_url" {
  description = "URL to access the deployed website"
  value       = "http://${aws_instance.web_server.public_ip}"
}

# Output the instance ID
output "instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.web_server.id
}

# Output the security group ID
output "security_group_id" {
  description = "ID of the security group"
  value       = aws_security_group.web_server_sg.id
}
