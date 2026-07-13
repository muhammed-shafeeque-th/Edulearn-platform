variable "release" {
  description = "Configuration for the Helm release"
  type = object({
    enabled            = optional(bool, true)
    name               = string
    chart              = string
    repository         = optional(string)
    version            = optional(string)
    namespace          = optional(string, "default")
    create_namespace   = optional(bool, false)
    atomic             = optional(bool, true)
    cleanup_on_fail    = optional(bool, true)
    timeout            = optional(number, 900)
    wait               = optional(bool, true)
    wait_for_jobs      = optional(bool, true)
    force_update       = optional(bool, false)
    recreate_pods      = optional(bool, false)
    dependency_update  = optional(bool, true)
    skip_crds          = optional(bool, false)
    replace            = optional(bool, false)
    verify             = optional(bool, false)
    max_history        = optional(number, 5)
    description        = optional(string)
    # Repository auth
    repository_username = optional(string)
    repository_password = optional(string)
    repository_ca_file  = optional(string)
    repository_cert_file = optional(string)
    repository_key_file = optional(string)
  })

  validation {
    condition     = length(var.release.name) > 0
    error_message = "Release name cannot be empty."
  }

  validation {
    condition     = length(var.release.chart) > 0
    error_message = "Chart name cannot be empty."
  }
}

variable "values" {
  description = "List of values files or rendered YAML"
  type        = list(string)
  default     = []
}

variable "set" {
  description = "List of Helm set values"
  type = list(object({
    name  = string
    value = string
    type  = optional(string, "auto")
  }))
  default = []
}

variable "set_sensitive" {
  description = "List of sensitive Helm set values"
  type = list(object({
    name  = string
    value = string
    type  = optional(string, "auto")
  }))
  default = []
}

variable "set_list" {
  description = "List of Helm set_list values"
  type = list(object({
    name  = string
    value = list(string)
  }))
  default = []
}

variable "postrender" {
  description = "Postrender configuration"
  type = object({
    binary_path = string
    args        = optional(list(string), [])
  })
  default = null
}

variable "depends_on_resources" {
  description = "Resources this release depends on"
  type        = any
  default     = []
}

variable "common_labels" {
  description = "Common labels to apply"
  type        = map(string)
  default     = {}
}