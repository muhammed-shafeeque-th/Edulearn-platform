


module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  enable_irsa = true

  cluster_name                    = var.cluster_name
  cluster_version                 = var.cluster_version
  cluster_endpoint_public_access  = false
  cluster_endpoint_private_access = true

  vpc_id                   = var.vpc_id
  subnet_ids               = var.private_subnet_ids
  control_plane_subnet_ids = var.private_subnet_ids
  # cluster_additional_security_group_ids = [aws_security_group.add_sg_eks.id]

  # Optional: Adds the current caller identity as an administrator via cluster access entry 
  # enable_cluster_creator_admin_permissions = true # No needed cause we explicitly configure iam user though access_entry



  cluster_security_group_additional_rules = {

    bastion = {
      protocol                 = "tcp"
      from_port                = 443
      to_port                  = 443
      type                     = "ingress"
      source_security_group_id = var.bastion_sg_id
    }
  }

  # node_security_group_additional_rules = {
  #   ingress_self_all = {
  #     protocol  = "-1"
  #     from_port = 0
  #     to_port   = 0
  #     type      = "ingress"
  #     self      = true
  #   }
  # }


  # Access entries
  access_entries = {
    terraform_user = {
      principal_arn = var.terraform_user_arn
      policy_associations = {
        admin = {
          policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
          access_scope = {
            type = "cluster"
          }
        }
      }
    }
  }

  cluster_addons = {
    coredns    = { most_recent = true }
    kube-proxy = { most_recent = true }
    vpc-cni    = { most_recent = true }
    eks-pod-identity-agent = {
      before_compute = true
    }

    aws-ebs-csi-driver = {
      most_recent              = true
      service_account_role_arn = module.ebs_csi_irsa_role.iam_role_arn
    }
  }

  eks_managed_node_group_defaults = {
    instance_types = ["t3.large"]
  }

  eks_managed_node_groups = {
    main = {
      min_size                   = 4
      max_size                   = 10
      desired_size               = 4
      instance_types             = ["c7i-flex.large"]
      capacity_type              = "SPOT"
      disk_size                  = 35
      use_custom_launch_template = false # Important to apply disk size!

      remote_access = {
        ec2_ssh_key               = var.key_name
        source_security_group_ids = [var.bastion_sg_id]
      }
    }
  }

  tags = var.tags
}
