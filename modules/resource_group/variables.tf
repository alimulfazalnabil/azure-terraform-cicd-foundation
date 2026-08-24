variable "name" {
  type        = string
  description = "The name of the Azure Resource Group."
}

variable "location" {
  type        = string
  description = "The Azure region in which to create the Resource Group (e.g., 'eastus')."
}

variable "tags" {
  type        = map(string)
  description = "A map of tags to apply to the Resource Group."
  default     = {}
}
