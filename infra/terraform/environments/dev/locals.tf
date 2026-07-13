locals {
  environment = "dev"
  name        = "edulearn-${local.environment}"
  tags = {
    Project     = "Edulearn"
    Environment = local.environment
    ManagedBy   = "Terraform"
  }

  outputs_map = {
    bastion_public_ip    = module.bastion.bastion_public_ip
    eks_cluster_endpoint = module.eks.cluster_endpoint
    cluster_name         = module.eks.cluster_name
    vpc_id               = module.network.vpc_id
  }
}
