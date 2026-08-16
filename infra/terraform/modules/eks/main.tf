


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

  // Even though aws eks module implicitly set this, write this for consistency
  node_security_group_additional_rules = {
    ingress_self_all = {
      description = "Allow all traffic between worker nodes"
      protocol    = "-1"
      from_port   = 0
      to_port     = 0
      type        = "ingress"
      self        = true
    }

    egress_all = {
      description      = "Allow all outbound traffic"
      protocol         = "-1"
      from_port        = 0
      to_port          = 0
      type             = "egress"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    }
  }


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
    coredns = {
      addon_version     = "v1.11.4-eksbuild.24"
      resolve_conflicts = "OVERWRITE"

    }

    kube-proxy = {
      addon_version     = "v1.31.14-eksbuild.6"
      resolve_conflicts = "OVERWRITE"

    }

    vpc-cni = {
      addon_version     = "v1.21.0-eksbuild.4"
      resolve_conflicts = "OVERWRITE"
      before_compute    = true

    }

    eks-pod-identity-agent = {
      addon_version     = "v1.3.8-eksbuild.2"
      resolve_conflicts = "OVERWRITE"

    }

    aws-ebs-csi-driver = {
      addon_version            = "v1.58.0-eksbuild.1"
      service_account_role_arn = module.ebs_csi_irsa_role.iam_role_arn
      resolve_conflicts        = "OVERWRITE"

    }
  }

  eks_managed_node_group_defaults = {
    instance_types             = ["c7i-flex.large"]
    disk_size                  = 35
    capacity_type              = "ON_DEMAND"
    use_custom_launch_template = false
  }

  eks_managed_node_groups = {

    stateful_1a = {
      subnet_ids   = [var.private_subnet_ids[0]] # ap-south-1a
      min_size     = 1
      desired_size = 1
      max_size     = 3

      capacity_type  = "ON_DEMAND"
      instance_types = ["c7i-flex.large"]
      disk_size      = 50

      labels = {
        workload = "stateful"
        topology = "ap-south-1a"
      }

      taints = {
        stateful = {
          key    = "workload"
          value  = "stateful"
          effect = "NO_SCHEDULE"
        }
      }
    }
    workers_1a = {
      subnet_ids    = [var.private_subnet_ids[0]]
      min_size      = 1
      desired_size  = 1
      max_size      = 4
      capacity_type = "SPOT"
      instance_types = [
        "c7i-flex.large",
      ]

      # remote_access = {
      #   ec2_ssh_key               = var.key_name
      #   source_security_group_ids = [var.bastion_sg_id]
      # }

      labels = {
        topology = "ap-south-1a"
        workload = "stateless"
      }
    }

    workers_1b = {
      subnet_ids    = [var.private_subnet_ids[1]]
      min_size      = 1
      desired_size  = 1
      max_size      = 4
      capacity_type = "SPOT"
      instance_types = [
        "c7i-flex.large",
        "t3a.medium",
      ]


      # remote_access = {
      #   ec2_ssh_key               = var.key_name
      #   source_security_group_ids = [var.bastion_sg_id]
      # }

      labels = {
        topology = "ap-south-1b"
        workload = "stateless"

      }
    }

    workers_1c = {
      subnet_ids    = [var.private_subnet_ids[2]]
      min_size      = 1
      desired_size  = 1
      max_size      = 4
      capacity_type = "SPOT"
      instance_types = [
        "c7i-flex.large",
      ]

      # remote_access = {
      #   ec2_ssh_key               = var.key_name
      #   source_security_group_ids = [var.bastion_sg_id]
      # }

      labels = {
        topology = "ap-south-1c"
        workload = "stateless"

      }
    }
  }

  tags = var.tags
}
