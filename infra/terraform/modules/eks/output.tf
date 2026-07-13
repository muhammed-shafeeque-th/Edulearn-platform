
output "cluster_name" {
  value = module.eks.cluster_name
}

output "cluster_endpoint" {
  value = module.eks.cluster_endpoint
}

output "cluster_security_group_id" {
  value = module.eks.cluster_security_group_id
}

output "oidc_provider_arn" {
  value = module.eks.oidc_provider_arn
}
output "oidc_provider_url" {
  # provider_url = replace(module.eks..identity[0].oidc[0].issuer, "https://", "")
  value = module.eks.cluster_oidc_issuer_url
}

