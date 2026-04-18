variable "name" {
  description = "Nom du Resource Group"
  type        = string
}
variable "location" {
  description = "Region Azure"
  type        = string
  default     = "West Europe"
}
variable "tags" {
  description = "Tags Azure"
  type        = map(string)
  default     = {}
}