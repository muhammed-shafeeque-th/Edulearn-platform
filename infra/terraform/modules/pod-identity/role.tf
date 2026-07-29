data "aws_iam_policy_document" "assume_role" {

  statement {

    effect = "Allow"

    actions = [
      "sts:AssumeRole",
      "sts:TagSession"
    ]

    principals {

      type = "Service"

      identifiers = [
        "pods.eks.amazonaws.com"
      ]
    }


  }

}

resource "aws_iam_role" "this" {

  count = var.create_role ? 1 : 0

  name = var.role_name

  # assume_role_policy = jsonencode({

  assume_role_policy = data.aws_iam_policy_document.assume_role.json

  tags = {
    ManagedBy = "Terraform"
  }
}

resource "aws_iam_role_policy_attachment" "this" {

  # for_each = var.create_role    ? toset(local.attached_policy_arns)    : []
  for_each = var.create_role ? local.attached_policies : {}

  role       = aws_iam_role.this[0].name
  policy_arn = each.value
}