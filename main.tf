locals {
  location_short = {
    "UK South" = "uks"
    "UK West"  = "ukw"
  }

  resource_name_prefix = lower("${var.workload_name}-${local.location_short[var.location]}-${var.environment}")
  common_tags = merge(var.tags, {
    Environment = var.environment
    Workload    = var.workload_name
  })

  subnets = {
    app = {
      name             = "app-subnet"
      address_prefixes = [cidrsubnet(var.vnet_address_space, 8, 1)]
    }
    data = {
      name             = "data-subnet"
      address_prefixes = [cidrsubnet(var.vnet_address_space, 8, 2)]
    }
    privateendpoint = {
      name             = "privateendpoint-subnet"
      address_prefixes = [cidrsubnet(var.vnet_address_space, 8, 3)]
    }
  }
}

resource "azurerm_resource_group" "main" {
  name     = "rg-${local.resource_name_prefix}"
  location = var.location
  tags     = local.common_tags
}

# module "virtual_network" {
#   source  = "Azure/avm-res-network-virtualnetwork/azurerm"
#   version = "~> 0.10"

#   name                = "vnet-${local.resource_name_prefix}"
#   location            = azurerm_resource_group.main.location
#   resource_group_name = azurerm_resource_group.main.name

#   address_space = [var.vnet_address_space]

#   subnets = {
#     for key, subnet in local.subnets : key => {
#       name             = subnet.name
#       address_prefixes = subnet.address_prefixes
#       network_security_group = {
#         id = azurerm_network_security_group.subnets[key].id
#       }
#     }
#   }

#   peerings = {
#     hub = {
#       name                         = "peer-to-hub"
#       remote_virtual_network_id    = var.hub_vnet_id
#       allow_virtual_network_access = true
#       allow_forwarded_traffic      = true
#       allow_gateway_transit        = false
#       use_remote_gateways          = true
#     }
#   }

#   tags = local.common_tags
# }

resource "azurerm_network_security_group" "subnets" {
  for_each = local.subnets

  name                = "nsg-${each.value.name}-${var.environment}"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  security_rule {
    name                       = "DenyAllInbound"
    priority                   = 4096
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = local.common_tags
}

# module "key_vault" {
#   source  = "Azure/avm-res-keyvault-vault/azurerm"
#   version = "~> 0.9"

#   name                = "kv-${replace(local.resource_name_prefix, "-", "")}"
#   location            = azurerm_resource_group.main.location
#   resource_group_name = azurerm_resource_group.main.name
#   tenant_id           = data.azurerm_client_config.current.tenant_id

#   sku_name                    = "standard"
#   enabled_for_disk_encryption = true
#   purge_protection_enabled    = true
#   soft_delete_retention_days  = 7

#   public_network_access_enabled = false

#   network_acls = {
#     bypass         = "AzureServices"
#     default_action = "Deny"
#   }

#   role_assignments = {
#     deployment_user_secrets = {
#       role_definition_id_or_name = "Key Vault Secrets Officer"
#       principal_id               = data.azurerm_client_config.current.object_id
#     }
#   }

#   private_endpoints = {
#     vault = {
#       name                            = "pe-${local.resource_name_prefix}-kv"
#       subnet_resource_id              = module.virtual_network.subnets["privateendpoint"].resource_id
#       subresource_name                = ["vault"]
#       private_dns_zone_resource_ids   = []
#       is_manual_connection            = false
#       private_service_connection_name = "psc-${local.resource_name_prefix}-kv"
#     }
#   }

#   tags = local.common_tags
# }

# module "storage_account" {
#   source  = "Azure/avm-res-storage-storageaccount/azurerm"
#   version = "~> 0.2"

#   name                = "st${replace(replace(local.resource_name_prefix, "-", ""), "_", "")}"
#   location            = azurerm_resource_group.main.location
#   resource_group_name = azurerm_resource_group.main.name

#   account_tier                      = "Standard"
#   account_replication_type          = "LRS"
#   account_kind                      = "StorageV2"
#   is_hns_enabled                    = true
#   infrastructure_encryption_enabled = true

#   public_network_access_enabled = false

#   network_rules = {
#     default_action = "Deny"
#     bypass         = ["AzureServices"]
#   }

#   private_endpoints = {
#     dfs = {
#       name                            = "pe-${local.resource_name_prefix}-st-dfs"
#       subnet_resource_id              = module.virtual_network.subnets["privateendpoint"].resource_id
#       subresource_name                = ["dfs"]
#       private_dns_zone_resource_ids   = []
#       is_manual_connection            = false
#       private_service_connection_name = "psc-${local.resource_name_prefix}-st-dfs"
#     }
#   }

#   tags = local.common_tags
# }
