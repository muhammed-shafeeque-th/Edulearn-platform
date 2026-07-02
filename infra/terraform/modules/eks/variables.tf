variable "cluster_name" {
  type = string
}

variable "cluster_version" {
  type    = string
  default = "1.31"
}

variable "vpc_id" {
  type = string
}

variable "private_subnet_ids" {
  type = list(string)
}

variable "terraform_user_arn" {
  type = string
}

variable "key_name" {
  description = "SSH key pair name"
  type        = string
}

variable "bastion_sg_id" {
  description = "Bastion host security group id"
  type = string
}

variable "tags" {
  type    = map(string)
  default = {}
}