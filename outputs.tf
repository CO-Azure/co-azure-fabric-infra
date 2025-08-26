output "tenant_id" {
  value       = data.azurerm_client_config.current.tenant_id
  description = "The Tenant ID for the AzureRM Provider."

}
