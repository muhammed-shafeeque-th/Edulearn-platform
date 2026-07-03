
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
