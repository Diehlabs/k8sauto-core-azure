output "tags" {
  value = local.tags
}

output "ssh_key" {
  value     = tls_private_key.ssh_key
  sensitive = true
}

output "ssh_key_b64" {
  value     = base64encode(tls_private_key.ssh_key.private_key_pem)
  sensitive = true
}

output "subnets" {
  value = {
    control = azurerm_subnet.akscontrolsub
    nodes   = azurerm_subnet.aksnodesub
  }
}
