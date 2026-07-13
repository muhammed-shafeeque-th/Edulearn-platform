output "name" {
  description = "Name of the Helm release"
  value       = try(helm_release.this[0].name, null)
}

output "namespace" {
  description = "Namespace of the Helm release"
  value       = try(helm_release.this[0].namespace, null)
}

output "version" {
  description = "Version of the Helm release"
  value       = try(helm_release.this[0].version, null)
}

output "status" {
  description = "Status of the Helm release"
  value       = try(helm_release.this[0].status, null)
}

output "metadata" {
  description = "Metadata of the Helm release"
  value       = try(helm_release.this[0].metadata, null)
}

output "manifest" {
  description = "Manifest of the Helm release"
  value       = try(helm_release.this[0].manifest, null)
}
