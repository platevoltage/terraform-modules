resource "aws_security_group" "aurora_sg" {
  name        = "${var.aurora_config.name_prefix}-aurora-serverless-v2"
  description = "Allow PostgreSQL access to Aurora"
  vpc_id      = var.aurora_config.vpc_id

  ingress {
    description     = "PostgreSQL access"
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [var.aurora_config.ecs_task_sg_id]
    cidr_blocks     = []
    # cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "${var.aurora_config.name_prefix}-aurora-serverless-v2"
  }
}

resource "aws_db_subnet_group" "aurora_subnet_group" {
  name        = "${local.db_name}-aurora-subnet-group"
  description = "${local.db_name} Aurora subnet group"
  subnet_ids  = var.aurora_config.private_subnet_ids
}

resource "aws_rds_cluster" "aurora_serverless_v2" {
  cluster_identifier = "${var.aurora_config.name_prefix}-cluster"
  engine             = "aurora-postgresql"
  engine_mode        = "provisioned"
  # engine_version omitted so AWS uses a supported default for aurora-postgresql
  database_name                = "${local.db_name}_db"
  master_username              = "${local.db_name}_admin"
  manage_master_user_password  = true
  db_subnet_group_name         = aws_db_subnet_group.aurora_subnet_group.name
  vpc_security_group_ids       = [aws_security_group.aurora_sg.id]
  skip_final_snapshot          = true
  apply_immediately            = false
  preferred_maintenance_window = "sun:05:00-sun:06:00"
  preferred_backup_window      = "04:00-05:00"
  backup_retention_period      = 3

  serverlessv2_scaling_configuration {
    min_capacity = 0.5
    max_capacity = 2
  }
}

resource "aws_rds_cluster_instance" "aurora_instance" {
  identifier                            = "${var.aurora_config.name_prefix}-instance-1"
  cluster_identifier                    = aws_rds_cluster.aurora_serverless_v2.id
  instance_class                        = "db.serverless"
  engine                                = aws_rds_cluster.aurora_serverless_v2.engine
  performance_insights_enabled          = true
  performance_insights_retention_period = 7
  # engine_version omitted to follow cluster version
}
