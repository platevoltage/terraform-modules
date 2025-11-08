module "cloudwatch_exporter_iam" {
  source         = "../../../modules/cloudwatch-exporter-iam"
  task_role_name = local.fargate_ecs_task_role
  region         = local.region
  account_id     = local.account_id
}