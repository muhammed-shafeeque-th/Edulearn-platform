locals {
  release = var.release
  common_labels = merge({
    "app.kubernetes.io/managed-by" = "terraform"
  }, var.common_labels)
}

resource "helm_release" "this" {
  count = local.release.enabled ? 1 : 0

  name             = local.release.name
  chart            = local.release.chart
  repository       = local.release.repository
  version          = local.release.version
  namespace        = local.release.namespace
  create_namespace = local.release.create_namespace

  atomic            = local.release.atomic
  cleanup_on_fail   = local.release.cleanup_on_fail
  timeout           = local.release.timeout
  wait              = local.release.wait
  wait_for_jobs     = local.release.wait_for_jobs
  force_update      = local.release.force_update
  recreate_pods     = local.release.recreate_pods
  dependency_update = local.release.dependency_update
  skip_crds         = local.release.skip_crds
  replace           = local.release.replace
  verify            = local.release.verify
  max_history       = local.release.max_history
  description       = local.release.description

  repository_username  = local.release.repository_username
  repository_password  = local.release.repository_password
  repository_ca_file   = local.release.repository_ca_file
  repository_cert_file = local.release.repository_cert_file
  repository_key_file  = local.release.repository_key_file

  values = var.values

  # set           = [for item in coalesce(var.set, []) : { "name" : item.name, "value" : item.value }]
  # set_sensitive = [for item in coalesce(var.set_sensitive, []) : { "name" : item.name, "value" : item.value }]


  dynamic "set" {
    for_each = coalesce(var.set, [])
    content {
      name  = set.value.name
      value = set.value.value
      type  = try(set.value.type, null)
    }
  }

  dynamic "set_sensitive" {
    for_each = coalesce(var.set_sensitive, [])
    content {
      name  = set_sensitive.value.name
      value = set_sensitive.value.value
      type  = try(set_sensitive.value.type, null)
    }
  }

  dynamic "set_list" {
    for_each = coalesce(var.set_list, [])
    content {
      name  = set_list.value.name
      value = set_list.value.value
    }
  }

  dynamic "postrender" {
    for_each = var.postrender != null ? [var.postrender] : []
    content {
      binary_path = postrender.value.binary_path
      args        = postrender.value.args
    }
  }

  # depends_on = var.depends_on_resources

  lifecycle {
    ignore_changes = [
      metadata,
    ]
  }
}
