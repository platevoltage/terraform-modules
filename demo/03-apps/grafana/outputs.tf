output "names" {
  sensitive   = false
  description = "All decrypted SSM parameters under the given path"
  value       = local.names
}
