output "ecs_service_name" {
  value = coalesce(
    try(aws_ecs_service.ecs_app_service_rolling["this"].name, null),
    try(aws_ecs_service.ecs_app_service_codedeploy["this"].name, null)
  )
}

output "ecs_task_role_name" {
  value       = aws_iam_role.ecs_task_role.name
  description = "The name of the ECS task role."
}

output "task_name" {
  value       = var.ecs_service_config.task_name
  description = "The name of the app that this service deploys."
}


