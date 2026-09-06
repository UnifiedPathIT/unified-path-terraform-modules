output "instance_id" {
  description = "ID of the EC2 instance."
  value       = aws_instance.this.id
}

output "public_ip" {
  description = "Public IP address (null if associate_public_ip is false)."
  value       = aws_instance.this.public_ip
}

output "public_dns" {
  description = "Public DNS name of the instance."
  value       = aws_instance.this.public_dns
}

output "security_group_id" {
  description = "ID of the instance's security group."
  value       = aws_security_group.this.id
}

output "ami_id" {
  description = "AMI the instance launched from."
  value       = local.ami_id
}
