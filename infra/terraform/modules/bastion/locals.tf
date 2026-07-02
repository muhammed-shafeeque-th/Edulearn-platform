locals {
  common_tags = {
    ManagedBy   = "Terraform"
    Project     = "Edulearn"
    Component   = "Bastion"
    Environment = var.environment
  }
}