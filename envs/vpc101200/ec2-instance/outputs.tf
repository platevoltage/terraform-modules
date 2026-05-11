output "instance_id" {
  value = module.ec2_instance.instance_id
}

output "private_ip" {
  value = module.ec2_instance.private_ip
}

output "security_group_id" {
  value = module.ec2_instance.security_group_id
}
