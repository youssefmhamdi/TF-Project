variable "prefix-spoke" {
  description = "Prefix for spoke resources"
  type        = string
  default     = "sandbox"
}

variable "spoke-name" {
  description = "Name of the spoke"
  type        = string
  default     = "spoke"
}

variable "location" {
  description = "Azure region for resources"
  type        = string
  default     = "North Europe"
}

variable "spoke-address-space" {
  description = "Address space for the spoke VNet"
  type        = string
  default     = "10.1.0.0/16"
}

variable "spoke-subnet-address-space" {
  description = "Address space for the spoke subnet"
  type        = string
  default     = "10.1.0.0/24"
}

variable "hub-vnet-id" {
  description = "ID of the hub VNet to connect to"
  type        = string
}

variable "ip-vm-nva" {
  description = "IP address of the NVA VM in the hub"
  type        = string
  default     = "10.0.0.4"
}

variable "hub-rg-name" {
    description = "Name of the hub resource group"
    type        = string
    default     = "rg-hub"
}