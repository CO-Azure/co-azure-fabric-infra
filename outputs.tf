# output "tenant_id" {
#   value       = data.azurerm_client_config.current.tenant_id
#   description = "The Tenant ID for the AzureRM Provider."
# }

# output "resource_group" {
#   description = "Resource group information"
#   value = {
#     id       = azurerm_resource_group.main.id
#     name     = azurerm_resource_group.main.name
#     location = azurerm_resource_group.main.location
#   }
# }

# output "virtual_network" {
#   description = "Virtual network information"
#   value = {
#     id            = module.virtual_network.resource_id
#     name          = module.virtual_network.name
#     address_space = module.virtual_network.address_space
#     subnets = {
#       for key, subnet in module.virtual_network.subnets : key => {
#         id               = subnet.resource_id
#         name             = subnet.name
#         address_prefixes = subnet.address_prefixes
#       }
#     }
#   }
# }

# output "network_security_groups" {
#   description = "Network security group information"
#   value = {
#     for key, nsg in azurerm_network_security_group.subnets : key => {
#       id   = nsg.id
#       name = nsg.name
#     }
#   }
# }

# output "key_vault" {
#   description = "Key Vault information"
#   value = {
#     id                  = module.key_vault.resource_id
#     name                = module.key_vault.name
#     vault_uri           = module.key_vault.vault_uri
#     private_endpoint_ip = try(module.key_vault.private_endpoints["vault"].ip_configurations[0].private_ip_address, null)
#   }
#   sensitive = true
# }

# output "storage_account" {
#   description = "Storage account information"
#   value = {
#     id                      = module.storage_account.resource_id
#     name                    = module.storage_account.name
#     primary_dfs_endpoint    = module.storage_account.primary_dfs_endpoint
#     private_endpoint_ip     = try(module.storage_account.private_endpoints["dfs"].ip_configurations[0].private_ip_address, null)
#   }
#   sensitive = true
# }

# output "private_endpoints" {
#   description = "Private endpoint information for integration with central DNS zones"
#   value = {
#     key_vault = {
#       name        = try(module.key_vault.private_endpoints["vault"].name, null)
#       ip_address  = try(module.key_vault.private_endpoints["vault"].ip_configurations[0].private_ip_address, null)
#       fqdn        = "${module.key_vault.name}.vault.azure.net"
#       subnet_id   = module.virtual_network.subnets["privateendpoint"].resource_id
#     }
#     storage_dfs = {
#       name        = try(module.storage_account.private_endpoints["dfs"].name, null)
#       ip_address  = try(module.storage_account.private_endpoints["dfs"].ip_configurations[0].private_ip_address, null)
#       fqdn        = "${module.storage_account.name}.dfs.core.windows.net"
#       subnet_id   = module.virtual_network.subnets["privateendpoint"].resource_id
#     }
#   }
#   sensitive = true
# }
