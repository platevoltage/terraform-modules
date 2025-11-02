output "aurora_outputs" {
  description = "All Aurora-related outputs as a single object"
  value = {
    account_id                     = local.aurora_config.account_id
    env                            = local.aurora_config.env
    aws_region                     = local.aurora_config.region
    aurora_cluster_endpoint        = module.aurora.aurora_cluster_endpoint
    aurora_cluster_reader_endpoint = module.aurora.aurora_cluster_reader_endpoint
    aurora_database_name           = module.aurora.aurora_database_name
    aurora_master_username         = module.aurora.aurora_master_username
    aurora_security_group_id       = module.aurora.aurora_security_group_id
    aurora_db_subnet_group         = module.aurora.aurora_db_subnet_group
    aurora_vpc_id                  = module.aurora.aurora_vpc_id
    aurora_private_subnet_ids      = module.aurora.aurora_private_subnet_ids
    aurora_port                    = module.aurora.aurora_port
    # aurora_cluster_endpoint        = module.aurora.aurora_cluster_endpoint
    # aurora_cluster_reader_endpoint = module.aurora.aws_rds_cluster.aurora_serverless_v2.reader_endpoint
    # aurora_database_name           = module.aurora.aws_rds_cluster.aurora_serverless_v2.database_name
    # aurora_master_username         = module.aurora.aws_rds_cluster.aurora_serverless_v2.master_username
    # aurora_security_group_id       = module.aurora.aws_security_group.aurora_sg.id
    # aurora_db_subnet_group         = module.aurora.aws_db_subnet_group.aurora_subnet_group.name
    # aurora_vpc_id                  = local.aurora_config.vpc_id
    # aurora_private_subnet_ids      = local.aurora_config.private_subnet_ids
  }
}