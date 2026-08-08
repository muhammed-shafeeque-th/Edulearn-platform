module "this" {

  source = "../../modules/s3-bucket"

  bucket = var.bucket

  versioning = var.versioning

  encryption =var.encryption

  public_access = {
    block_public_acls       = false
    ignore_public_acls      = false
    block_public_policy     = false
    restrict_public_buckets = false
  }

  ownership = {
    object_ownership = "BucketOwnerPreferred"
  }

  cors_rules = [
    {
      allowed_methods = ["GET", "PUT"]

      allowed_origins = ["*"]

      allowed_headers = ["*"]

      max_age_seconds = 3600
    }
  ]

  policy = data.aws_iam_policy_document.assets_bucket.json

}

data "aws_iam_policy_document" "assets_bucket" {

  statement {

    sid = "PublicRead"

    actions = [
      "s3:GetObject",

      "s3:PutObject",

      "s3:DeleteObject"

    ]

    resources = [
      "${module.assets_bucket.arn}/*"
    ]

    principals {
      type        = "*"
      identifiers = ["*"]
    }

  }

}
