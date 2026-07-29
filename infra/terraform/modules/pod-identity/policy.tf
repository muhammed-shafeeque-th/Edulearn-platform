resource "aws_iam_policy" "this" {

  count = var.create_policy ? 1 : 0


  name = var.policy_name

  policy = var.policy_document

  tags = {
    ManagedBy = "Terraform"
  }
}
