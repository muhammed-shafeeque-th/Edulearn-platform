locals {
  common_tags = {
    ManagedBy   = "Terraform"
    Project     = "Edulearn"
    Environment = var.environment
  }
}