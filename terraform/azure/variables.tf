variable "subscription_id" {
  type      = string
  sensitive = true
}

variable "location" {
  type    = string
  default = "West Europe"
}

variable "project" {
  type    = string
  default = "devopsdemo"
}