output "bastion_public_ip" {
  value = module.bastion.bastion_public_ip
}

output "eks_cluster_endpoint" {
  value = module.eks.cluster_endpoint
}

output "cluster_name" {
  value = module.eks.cluster_name
}

output "vpc_id" {
  value = module.network.vpc_id
}
