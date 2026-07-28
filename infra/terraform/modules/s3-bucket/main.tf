resource "aws_s3_bucket" "this" {

  bucket = var.bucket.name

  force_destroy = var.bucket.force_destroy

  object_lock_enabled = var.bucket.object_lock_enabled

  tags = local.tags

}


resource "aws_s3_bucket_versioning" "this" {

  bucket = aws_s3_bucket.this.id

  versioning_configuration {

    status = var.versioning.enabled ? "Enabled" : "Suspended"

    mfa_delete = var.versioning.mfa_delete ? "Enabled" : "Disabled"

  }

}

resource "aws_s3_bucket_server_side_encryption_configuration" "this" {

  count = var.encryption.enabled ? 1 : 0

  bucket = aws_s3_bucket.this.id

  rule {

    bucket_key_enabled = var.encryption.bucket_key_enabled

    apply_server_side_encryption_by_default {

      sse_algorithm = var.encryption.algorithm

      kms_master_key_id = var.encryption.kms_key_id

    }

  }

}


resource "aws_s3_bucket_public_access_block" "this" {

  bucket = aws_s3_bucket.this.id

  block_public_acls = var.public_access.block_public_acls

  block_public_policy = var.public_access.block_public_policy

  ignore_public_acls = var.public_access.ignore_public_acls

  restrict_public_buckets = var.public_access.restrict_public_buckets

}

resource "aws_s3_bucket_ownership_controls" "this" {

  bucket = aws_s3_bucket.this.id

  rule {

    object_ownership = var.ownership.object_ownership

  }

}


resource "aws_s3_bucket_lifecycle_configuration" "this" {

  count = length(var.lifecycle_rules) > 0 ? 1 : 0

  bucket = aws_s3_bucket.this.id

  dynamic "rule" {

    for_each = var.lifecycle_rules

    content {

      id = rule.value.id

      status = rule.value.enabled ? "Enabled" : "Disabled"

      filter {

        prefix = try(rule.value.prefix, null)

      }

      dynamic "transition" {

        for_each = try(rule.value.transition, null) != null ? [rule.value.transition] : []

        content {

          days = transition.value.days

          storage_class = transition.value.storage_class

        }

      }

      expiration {

        days = try(rule.value.expiration_days, null)

      }

    }

  }

}

resource "aws_s3_bucket_policy" "this" {

  count = var.policy != null ? 1 : 0

  bucket = aws_s3_bucket.this.id

  policy = var.policy

}

resource "aws_s3_bucket_logging" "this" {

  count = var.logging.enabled ? 1 : 0

  bucket = aws_s3_bucket.this.id

  target_bucket = var.logging.target_bucket

  target_prefix = var.logging.target_prefix

}

resource "aws_s3_bucket_cors_configuration" "this" {

  count = length(var.cors_rules) > 0 ? 1 : 0

  bucket = aws_s3_bucket.this.id

  dynamic "cors_rule" {

    for_each = var.cors_rules

    content {

      allowed_methods = cors_rule.value.allowed_methods

      allowed_origins = cors_rule.value.allowed_origins

      allowed_headers = cors_rule.value.allowed_headers

      expose_headers = cors_rule.value.expose_headers

      max_age_seconds = cors_rule.value.max_age_seconds

    }

  }

}
