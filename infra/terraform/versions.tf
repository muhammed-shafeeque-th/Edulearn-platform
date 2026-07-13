terraform {
  # Minimum required Terraform version
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.53"     # Allows 6.x and above
    }

  }
}