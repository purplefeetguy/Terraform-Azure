variable "environment_tag" {
  type        = string
  description = "Environment tag value"
}
variable "azure-rg-1" {
  type        = string
  description = "resource group 1"
}
variable "loc1" {
  description = "The location for this Lab environment"
  type        = string
}

variable "client_id" {}
variable "client_secret" {}
variable "subscription_id" {}
variable "tenant_id" {}