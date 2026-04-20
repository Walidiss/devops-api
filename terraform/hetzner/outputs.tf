output "vps_ip" {
  description = "IP publique du VPS"
  value       = hcloud_server.vps.ipv4_address
}
output "ssh_command" {
  description = "Commande SSH prête à l'emploi"
  value       = "ssh root@${hcloud_server.vps.ipv4_address}"
}