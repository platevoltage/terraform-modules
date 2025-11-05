resource "aws_security_group" "ecs_fargate_task" {
  description = "ECS Fargate task security group"
  name        = "${var.ecs_service_config.name_prefix}-ecs-fargate-task"
  vpc_id      = var.ecs_service_config.vpc_id

  lifecycle {
    create_before_destroy = true
  }

  tags = merge(var.ecs_service_config.common_tags, {
    Name = "${var.ecs_service_config.name_prefix}-ecs-fargate-task"
  })
}

### EGRESS
resource "aws_security_group_rule" "ecs_fargate_task_egress" {
  description = "ECS Fargate task Egress"
  type        = "egress"
  from_port   = 0
  to_port     = 65535
  protocol    = "all"

  cidr_blocks       = ["0.0.0.0/0"] # tfsec:ignore:AWS007
  security_group_id = aws_security_group.ecs_fargate_task.id
}

resource "aws_security_group_rule" "ecs_fargate_task_egress_v6" {
  description = "ECS Fargate task Egress"
  type        = "egress"
  from_port   = 0
  to_port     = 65535
  protocol    = "all"

  ipv6_cidr_blocks  = ["::/0"] # tfsec:ignore:AWS007
  security_group_id = aws_security_group.ecs_fargate_task.id
}

# INGRESS FROM ALB
resource "aws_security_group_rule" "from_alb_to_task" {
  description              = "Allow ALB to reach app port"
  type                     = "ingress"
  from_port                = var.ecs_service_config.app_port
  to_port                  = var.ecs_service_config.app_port
  protocol                 = "tcp"
  security_group_id        = aws_security_group.ecs_fargate_task.id
  source_security_group_id = var.ecs_service_config.alb_sg_id
}