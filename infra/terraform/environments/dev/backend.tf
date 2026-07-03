terraform {
  backend "s3" {
    bucket = "terraform-s3-backend-edulearn"
    key    = "environments/dev/terraform.tfstate"
    region = "ap-south-1"
    # dynamodb_table = "terraform-state-lock"  # Create this table if it doesn't exist
    encrypt      = true
    use_lockfile = true
  }
}