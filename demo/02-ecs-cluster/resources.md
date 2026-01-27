### AWS Resources

| Name | Type | Description |
|-----|-----|-------------|
| aws_ecs_cluster.ecs_app_cluster | resource | (inside ../../modules/ecs-cluster) |
| aws_ecs_cluster_capacity_providers.default | resource | (inside ../../modules/ecs-cluster) |
| aws_iam_policy.ecs_exec_secretsmanager | resource | Allow ECS execution role to read Secrets Manager for RDS cluster secrets in this account and region (inside ../../modules/ecs-cluster) |
| aws_iam_policy.ecs_execution_ssm_access | resource | (inside ../../modules/ecs-cluster) |
| aws_iam_policy.ssm_params_policy | resource | (Optionally) attach a policy for reading parameters from SSM under the execution role, if you prefer that design (inside ../../modules/ecs-cluster) |
| aws_iam_role.ecs_execution_role | resource | ECS Execution Role (used by ECS to pull images, manage logs, etc.) (inside ../../modules/ecs-cluster) |
| aws_iam_role.ecs_task_role | resource | ECS Task Role (used by your app containers at runtime) (inside ../../modules/ecs-cluster) |
| aws_iam_role_policy_attachment.ecs_exec_secretsmanager_attach | resource | (inside ../../modules/ecs-cluster) |
| aws_iam_role_policy_attachment.ecs_execution_attachment | resource | (inside ../../modules/ecs-cluster) |
| aws_iam_role_policy_attachment.ecs_execution_ssm_access | resource | (inside ../../modules/ecs-cluster) |
| aws_iam_role_policy_attachment.ssm_params_policy_attachment | resource | (inside ../../modules/ecs-cluster) |
| module.ecs_cluster | module |  |

## Data Sources

| Name | Type | Description |
|-----|-----|-------------|
| data.aws_iam_policy_document.ecs_execution_assume_role_policy | data source | (inside ../../modules/ecs-cluster) |
| data.aws_iam_policy_document.ecs_task_assume_role | data source | (inside ../../modules/ecs-cluster) |
| data.terraform_remote_state.base | data source | observability/prod/ecs-cluster/data.tf |
