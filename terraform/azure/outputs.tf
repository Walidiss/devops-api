output "resource_group" {
  value = module.rg.name
}
output "acr_login_server" {
  value = module.acr.login_server
}
output "acr_admin_username" {
  value     = module.acr.admin_username
  sensitive = true
}