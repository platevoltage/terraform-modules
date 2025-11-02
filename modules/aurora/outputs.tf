output "aurora_cluster_endpoint" {
  description = "The main endpoint for the Aurora PostgreSQL cluster"
  value       = aws_rds_cluster.aurora_serverless_v2.endpoint
}

output "aurora_cluster_reader_endpoint" {
  description = "The reader endpoint for the Aurora PostgreSQL cluster"
  value       = aws_rds_cluster.aurora_serverless_v2.reader_endpoint
}

output "aurora_database_name" {
  description = "The name of the database created in the Aurora PostgreSQL cluster"
  value       = aws_rds_cluster.aurora_serverless_v2.database_name
}

output "aurora_master_username" {
  description = "The master username for the Aurora PostgreSQL cluster"
  value       = aws_rds_cluster.aurora_serverless_v2.master_username
}

output "aurora_security_group_id" {
  description = "The ID of the security group attached to the Aurora cluster"
  value       = aws_security_group.aurora_sg.id
}

output "aurora_db_subnet_group" {
  description = "The name of the DB subnet group used by the Aurora cluster"
  value       = aws_db_subnet_group.aurora_subnet_group.name
}

output "aurora_vpc_id" {
  description = "The VPC ID for the Aurora cluster"
  value       = var.aurora_config.vpc_id
}

output "aurora_private_subnet_ids" {
  description = "The private subnet IDs where the Aurora cluster is deployed"
  value       = var.aurora_config.private_subnet_ids
}

output "aurora_port" {
  description = "Aurora PostgreSQL port"
  value       = aws_rds_cluster.aurora_serverless_v2.port
}
