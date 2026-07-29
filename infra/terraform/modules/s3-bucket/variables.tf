variable "bucket" {

  description = "S3 bucket configuration"

  type = object({

    name = string

    force_destroy = optional(bool, false)

    object_lock_enabled = optional(bool, false)

    tags = optional(map(string), {})

  })

}
variable "versioning" {

  type = object({

    enabled = optional(bool, true)

    mfa_delete = optional(bool, false)

  })

  default = {}

}

variable "encryption" {

  type = object({

    enabled = optional(bool, true)

    algorithm = optional(string, "aws:kms")

    kms_key_id = optional(string)

    bucket_key_enabled = optional(bool, true)

  })

  default = {}

}

variable "public_access" {

  type = object({

    block_public_acls = optional(bool, true)

    ignore_public_acls = optional(bool, true)

    block_public_policy = optional(bool, true)

    restrict_public_buckets = optional(bool, true)

  })

  default = {}

}

variable "ownership" {

  type = object({

    object_ownership = optional(string, "BucketOwnerEnforced")

  })

  default = {}

}

variable "lifecycle_rules" {

  type = list(object({

    id = string

    enabled = bool

    prefix = optional(string)

    transition = optional(object({

      days = number

      storage_class = string

    }))

    expiration_days = optional(number)

  }))

  default = []

}

variable "logging" {

  type = object({

    enabled = optional(bool, false)

    target_bucket = optional(string)

    target_prefix = optional(string)

  })

  default = {}

}

variable "cors_rules" {

  type = list(object({

    allowed_methods = list(string)

    allowed_origins = list(string)

    allowed_headers = optional(list(string), ["*"])

    expose_headers = optional(list(string), [])

    max_age_seconds = optional(number)

  }))

  default = []

}

variable "policy" {

  type = string

  default = null

}

variable "website" {

  type = object({

    enabled = optional(bool, false)

    index_document = optional(string)

    error_document = optional(string)

  })

  default = {}

}