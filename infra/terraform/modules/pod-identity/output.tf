output "role_arn" {

  value = local.role_arn
}

output "policy_arn" {

  value = local.policy_arn
}

output "association_id" {
  value = aws_eks_pod_identity_association.this.association_id
}