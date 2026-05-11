output "vpc_outputs" {
  value = module.vpc.vpc_outputs
}

output "vpc_id" {
  value = module.vpc.vpc_id
}

output "vpc_cidr" {
  value = module.vpc.vpc_cidr
}

output "private_subnet_ids" {
  value = module.vpc.private_subnet_ids
}
