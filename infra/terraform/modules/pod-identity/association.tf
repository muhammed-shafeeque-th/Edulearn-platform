resource "aws_eks_pod_identity_association" "this" {

  cluster_name = var.cluster_name

  namespace = var.namespace

  service_account = var.service_account

  role_arn = aws_iam_role.this.arn
}