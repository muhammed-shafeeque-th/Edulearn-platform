locals {

  tags = merge(

    {

      ManagedBy = "Terraform"

      Module = "s3-bucket"

    },

    var.bucket.tags

  )

}