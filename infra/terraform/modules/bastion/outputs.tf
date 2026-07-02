output "bastion_public_ip" {
  description = "Public IP of Bastion host"
  value       = aws_eip.bastion.public_ip
}

output "bastion_security_group_id" {
  description = "Security Group ID for Bastion"
  value       = aws_security_group.bastion.id
}

output "bastion_instance_id" {
  description = "Instance ID of Bastion"
  value       = aws_instance.bastion.id
}