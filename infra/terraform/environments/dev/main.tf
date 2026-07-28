
module "network" {
  source = "../../modules/network"

  environment     = var.environment
  name            = local.name
  vpc_cidr        = var.vpc_cidr
  azs             = var.azs
  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets
  tags            = local.tags
}

module "bastion" {
  source = "../../modules/bastion"

  name             = local.name
  vpc_id           = module.network.vpc_id
  public_subnet_id = module.network.public_subnets[0]
  instance_type    = var.instance_type
  key_name         = aws_key_pair.bastion_keypair.key_name
  tags             = local.tags
}

module "eks" {
  source = "../../modules/eks"

  cluster_name       = var.cluster_name
  vpc_id             = module.network.vpc_id
  private_subnet_ids = module.network.private_subnets
  terraform_user_arn = var.terraform_user_arn
  key_name           = aws_key_pair.bastion_keypair.key_name
  bastion_sg_id      = module.bastion.bastion_security_group_id
  tags               = local.tags
}

module "aws_lbc_pod_identity" {

  source          = "../../modules/pod-identity"
  cluster_name    = module.eks.cluster_name
  namespace       = "kube-system"
  service_account = "aws-load-balancer-controller"
  create_policy   = true
  role_name       = "aws-load-balancer-controller-role"
  policy_name     = "AWSLoadBalancerControllerIAMPolicy"
  policy_document = file("${path.module}/policies/aws-lbc-policy.json")
}
module "external_secret_pod_identity" {

  source          = "../../modules/pod-identity"
  cluster_name    = module.eks.cluster_name
  namespace       = "external-secrets"
  service_account = "external-secrets"
  role_name       = "external-secrets-pod-identity-role"
  create_policy   = true
  policy_name     = "ExternalSecretsManagerRead"
  policy_document = file("${path.module}/policies/external-secret-policy.json")
}

module "external_dns_pod_identity" {

  source          = "../../modules/pod-identity"
  cluster_name    = module.eks.cluster_name
  namespace       = "external-dns"
  service_account = "external-dns"
  role_name       = "external-dns-pod-identity-role"
  policy_name     = "AllowExternalDNSUpdates"
  create_policy   = true
  policy_document = file("${path.module}/policies/external-dns-policy.json")
}
module "loki_pod_identity" {

  source          = "../../modules/pod-identity"
  cluster_name    = module.eks.cluster_name
  namespace       = "observability"
  service_account = "loki"
  role_name       = "loki-pod-identity-role"
  create_policy   = true
  policy_name     = "AllowLokiS3Access"
  policy_document = file("${path.module}/policies/loki-policy.json")
}
module "tempo_pod_identity" {

  source          = "../../modules/pod-identity"
  cluster_name    = module.eks.cluster_name
  namespace       = "observability"
  service_account = "tempo"
  role_name       = "tempo-pod-identity-role"
  create_policy   = true
  policy_name     = "AllowTempoS3Access"
  policy_document = file("${path.module}/policies/tempo-policy.json")
}



module "ebs_csi_identity" {

  source          = "../../modules/pod-identity"
  cluster_name    = module.eks.cluster_name
  namespace       = "kube-system"
  service_account = "ebs-csi-controller-sa"
  role_name       = "ebs-csi-role"
  policy_arns = [
    "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
  ]
}

module "loki_bucket" {

  source = "../../modules/s3-bucket"

  bucket = {
    name          = "edulearn-loki"
    force_destroy = true
    tags = {
      Application = "EduLearn"
      Purpose     = "Loki Bucket"
    }
  }

  encryption = {
    enabled   = true
    algorithm = "aws:kms"
  }

}
module "tempo_bucket" {

  source = "../../modules/s3-bucket"
  bucket = {
    name          = "edulearn-tempo"
    force_destroy = true

    tags = {
      Application = "EduLearn"
      Purpose     = "Tempo Bucket"

    }
  }

  versioning = {
    enabled = true

  }
  encryption = {
    enabled   = true
    algorithm = "aws:kms"
  }
}
# Generate a key and registers it in AWS.

resource "tls_private_key" "bastion_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "bastion_keypair" {
  key_name   = "bastion-key"
  public_key = tls_private_key.bastion_key.public_key_openssh
}


# Save the private key locally
resource "local_file" "bastion_private_key" {
  content         = tls_private_key.bastion_key.private_key_pem
  filename        = "bastion-key.pem"
  file_permission = "0400"
}

resource "local_file" "terraform_outputs_yaml" {
  content  = yamlencode(local.outputs_map)
  filename = var.outputs_yaml_path
}

