locals {
  environment = "dev"
  name        = "edulearn-${local.environment}"
  tags = {
    Project     = "Edulearn"
    Environment = local.environment
    ManagedBy   = "Terraform"
  }
}