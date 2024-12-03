
output "web_instance_public_ip" {
  value = module.instances.web_instance_public_ip
}

output "db_instance_private_ip" {
  value = module.instances.db_instance_private_ip
}
