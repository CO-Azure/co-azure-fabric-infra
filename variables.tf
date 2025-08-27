variable "location" {
  description = "Azure region for resources"
  type        = string
  default     = "UK South"
  validation {
    condition     = contains(["UK South", "UK West"], var.location)
    error_message = "Location must be either 'UK South' or 'UK West'."
  }
}

variable "environment" {
  description = "Environment name (dev, test, prod)"
  type        = string
  validation {
    condition     = can(regex("^(dev|test|prod)$", var.environment))
    error_message = "Environment must be dev, test, or prod."
  }
}

variable "workload_name" {
  description = "Name of the workload"
  type        = string
}

variable "subscription_id" {
  description = "Azure subscription ID"
  type        = string
}

variable "vnet_address_space" {
  description = "CIDR block for the virtual network"
  type        = string
}

variable "hub_uksouth_vnet_id" {
  description = "Resource ID of the hub VNet for peering"
  type        = string
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default = {
    ManagedBy = "Terraform"
    Purpose   = "Baseline Infrastructure"
  }
}
