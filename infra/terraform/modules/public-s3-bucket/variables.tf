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
