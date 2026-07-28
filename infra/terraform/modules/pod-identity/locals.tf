locals {

  role_arn   = var.create_role ? aws_iam_role.this[0].arn : var.role_arn
  policy_arn = var.create_policy ? aws_iam_policy.this[0].arn : null
  role_name  = var.create_role ? aws_iam_role.this[0].name : element(reverse(split("/", var.role_arn)), 0)
  attached_policies = merge(
    {
      for idx, arn in var.policy_arns :
      "managed-${idx}" => arn
    },
    var.create_policy ? {
      customer = aws_iam_policy.this[0].arn
    } : {}
  )


}
