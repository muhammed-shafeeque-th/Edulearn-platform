data "aws_instances" "eks_nodes" {
  instance_tags = {
    "eks:cluster-name" = module.eks.cluster_name
  }

  filter {
    name   = "instance-state-name"
    values = ["running"]
  }

  depends_on = [module.eks]
}

// Additional security group for EKS
# resource "aws_security_group" "add_sg_eks" {
#   name   = "additional-eks-sg"
#   vpc_id = var.vpc_id
#   ingress {
#     description = "HTTPS from bastion host"
#     from_port   = 443
#     to_port     = 443
#     protocol    = "tcp"
#     security_groups = [var.bastion_sg_id]
#   }


#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   tags = {
#     Name = "additional-eks-sg"
#   }
# }
