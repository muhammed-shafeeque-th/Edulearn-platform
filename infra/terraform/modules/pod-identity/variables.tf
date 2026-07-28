variable "cluster_name" {
  type = string
}

variable "namespace" {
  type = string
}

variable "service_account" {
  type = string
}

variable "tags" {
  type    = map(string)
  default = {}
}

# IAM Role

variable "create_role" {
  type    = bool
  default = true
}

variable "role_name" {
  type    = string
  default = null
}

variable "role_arn" {
  type    = string
  default = null
}

# Customer Managed Policy

variable "create_policy" {
  type    = bool
  default = false
}

variable "policy_name" {
  type    = string
  default = null
}

variable "policy_document" {
  type    = string
  default = null
}

# Existing Policy ARNs

variable "policy_arns" {
  type    = list(string)
  default = []
}
