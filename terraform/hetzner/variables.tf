variable "hcloud_token" {
  description = "Token API Hetzner Cloud"
  type        = string
  sensitive   = true # masqué dans les logs
}
variable "ssh_public_key" {
  description = "Clé SSH publique pour accéder au serveur"
  type        = string
}
variable "location" {
  description = "Datacenter Hetzner"
  type        = string
  default     = "hel1" # Helsinki, Finland
}
variable "server_type" {
  description = "Type de serveur Hetzner"
  type        = string
  default     = "cx23" # 2 vCPU, 4GB RAM
}