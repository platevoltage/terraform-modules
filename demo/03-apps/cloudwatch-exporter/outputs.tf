output "ecs_service_name" {
  value       = module.ecs_service.ecs_service_name
  description = "The name of the ECS service"
}

output "task_name" {
  value       = module.ecs_service.task_name
  description = "The task name"
}