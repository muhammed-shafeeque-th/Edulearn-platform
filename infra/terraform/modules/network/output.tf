output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.this.vpc_id
}

output "public_subnets" {
  description = "List of public subnet IDs"
  value       = module.this.public_subnets
}

output "private_subnets" {
  description = "List of private subnet IDs"
  value       = module.this.private_subnets
}

output "azs" {
  description = "List of availability zones"
  value       = module.this.azs
}