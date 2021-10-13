output "tags" {
  value = local.tags
}

output "ssh_key" {
  value     = tls_private_key.ssh_key
  sensitive = true
}
