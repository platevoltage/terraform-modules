# ECS Cluster Module

Terraform module that provisions a production ready Amazon ECS cluster (Fargate) plus baseline IAM roles and policies required for running ECS services consistently.

This module is intended to be consumed by higher level stacks that provide networking (VPC/subnets), ingress (ALB), and application deployments (ECS service + CI/CD). It focuses on the shared compute control plane primitives: cluster, capacity providers, and IAM roles for task execution.

## What This Module Provisions

- An Amazon ECS cluster with Container Insights enabled.
- Default capacity provider strategy using `FARGATE`.
- ECS execution role with the AWS managed execution policy attached.
- Optional IAM policies attached to the execution role for:
  - SSM Parameter Store reads under provided path prefixes
  - Secrets Manager reads (as currently implemented)
- ECS task role intended for application runtime permissions (no permissions attached by default in this module).

## Usage

### Example

```hcl
module "ecs_cluster" {
  source = "./modules/ecs-cluster"

  ecs_cluster_config = {
    env                     = "prod"
    account_id               = "123456789012"
    aws_region               = "us-east-1"
    project                  = "space-rocket"
    project_name             = "space-rocket-prod"
    name_prefix              = "space-rocket-prod"

    # Used by execution-role SSM policies
    ssm_secret_path_prefixes = [
      "/space-rocket/prod/app1",
      "/space-rocket/prod/app2",
    ]

    # Provided for compatibility with upstream configs
    allowed_ips              = ["203.0.113.10/32"]
    ssh_key_name             = "space-rocket-prod-bastion-key"
    seed_bucket              = "space-rocket-prod-seed-bucket-123456789012"
    common_tags = {
      Env       = "prod"
      Project   = "space-rocket"
      ManagedBy = "terraform"
    }

    # Optional override
    cluster_name_override    = ""

  }
}
```

## Inputs

This module is configured using a single object input: `ecs_cluster_config`.

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| ecs_cluster_config | Composite config for cluster naming, tags, region and account context, and secret path prefixes used for SSM access policies. | object | see `variables.tf` | No |

### ecs_cluster_config schema

| Field | Description | Type | Required |
|------|-------------|------|----------|
| env | Environment name (dev, prod, etc.) | string | yes |
| account_id | AWS account id | string | yes |
| aws_region | AWS region | string | yes |
| project | Project identifier used in names and tags | string | yes |
| project_name | Project display name | string | yes |
| name_prefix | Name prefix used for cluster and IAM role names | string | yes |
| ssm_secret_path_prefixes | List of SSM Parameter Store base paths to grant read access under `/*` | list(string) | yes |
| common_tags | Tags applied to supported resources | map(string) | yes |
| allowed_ips | Reserved for upstream usage (not used directly by this module) | list(string) | yes |
| ssh_key_name | Reserved for upstream usage (not used directly by this module) | string | yes |
| seed_bucket | Reserved for upstream usage (not used directly by this module) | string | yes |
| cluster_name_override | If non empty, overrides the default cluster name | string | yes |
| ecs_execution_role_arn | Reserved for future override patterns (not consumed by this module) | string | yes |

> [!NOTE]
> This module creates its own ECS execution role and task role.  
> The `ecs_execution_role_arn` field exists in the schema but is not used by any resources in this module.

---

## Outputs

| Name | Description |
|------|-------------|
| ecs_cluster_id | ECS cluster id. |
| ecs_cluster_name | ECS cluster name. |
| ecs_execution_role_arn | ARN of the ECS execution role. |
| ecs_task_role_arn | ARN of the ECS task role. |
| ecs_task_role_name | Name of the ECS task role. |

---

## Resources

| Name | Type | Description |
|------|------|-------------|
| aws_ecs_cluster.ecs_app_cluster | resource | ECS cluster with Container Insights enabled. |
| aws_ecs_cluster_capacity_providers.default | resource | Sets FARGATE as the default capacity provider strategy. |
| aws_iam_role.ecs_execution_role | resource | Execution role assumed by `ecs-tasks.amazonaws.com`. |
| aws_iam_role_policy_attachment.ecs_execution_attachment | resource | Attaches `AmazonECSTaskExecutionRolePolicy` to the execution role. |
| aws_iam_policy.ssm_params_policy | resource | Allows SSM `GetParameters` under configured secret path prefixes. |
| aws_iam_policy.ecs_execution_ssm_access | resource | Allows SSM `GetParameter`, `GetParameters`, and `GetParametersByPath` under configured secret path prefixes. |
| aws_iam_policy.ecs_exec_secretsmanager | resource | Allows Secrets Manager reads for the configured secret ARN pattern and KMS decrypt via Secrets Manager. |
| aws_iam_role_policy_attachment.ssm_params_policy_attachment | resource | Attaches SSM read policy to the execution role. |
| aws_iam_role_policy_attachment.ecs_execution_ssm_access | resource | Attaches SSM by path policy to the execution role. |
| aws_iam_role_policy_attachment.ecs_exec_secretsmanager_attach | resource | Attaches Secrets Manager policy to the execution role. |
| aws_iam_role.ecs_task_role | resource | Task role assumed by `ecs-tasks.amazonaws.com` for application runtime permissions. |
| data.aws_iam_policy_document.ecs_execution_assume_role_policy | data source | Trust policy document for the ECS execution role. |
| data.aws_iam_policy_document.ecs_task_assume_role | data source | Trust policy document for the ECS task role. |

---

## Notes

- Container Insights is enabled by default to emit cluster level metrics and telemetry.
- The default capacity provider strategy uses FARGATE. You can extend this to include FARGATE_SPOT if desired.
- SSM access is granted to the execution role for all configured `ssm_secret_path_prefixes` with a `/*` suffix.
- The Secrets Manager policy currently contains a hardcoded secret ARN pattern and should be refactored to a variable driven list before reuse across environments.

---

## Related Projects

- `modules/ecs-service` consumes this module’s cluster and execution role outputs to run services and register task definitions.
- `modules/codepipeline` deploys into ECS services that run on this cluster.
- `modules/tg-fargate` provides target groups and listener rules fronting ECS services in the cluster.

