# ECS Cluster Module Demo

**Module** to provision a production ready Amazon ECS cluster that serves as the shared compute foundation for application workloads.


This Module builds on the Base Module Group and establishes a centralized ECS control plane using AWS Fargate. It creates the ECS cluster, capacity providers, execution and task IAM roles, and baseline permissions required to run containerized services securely and consistently. It is designed to be consumed by downstream application modules that deploy ECS services, CI CD pipelines, and ALB routing rules.

## What This Module Provisions

This Module provisions the following resources:

- An Amazon ECS cluster with Container Insights enabled for metrics and logs.
- Fargate capacity provider configuration with a default strategy.
- An ECS execution role used by ECS to pull images, write logs, and access secrets.
- An ECS task role intended for application runtime permissions.
- IAM policies and attachments for SSM Parameter Store and Secrets Manager access.
- Shared outputs intended for consumption by downstream ECS service and application modules.

## Prerequisites

- Base Module Group applied and available via Terraform remote state.
- Terraform state bucket and DynamoDB lock table.
- AWS credentials with permissions to create ECS and IAM resources.

## Usage

### Backend Configuration

Configure Terraform backend state file:

**backend.hcl**
```hcl
bucket         = "terraform-demo-state-dce2cf761e97"
key            = "terraform/state/ecs-cluster.tfstate"
region         = "us-east-1"
dynamodb_table = "terraform-state-locks"
```

## Remote State Dependency

This module consumes outputs from the Base Module Group.

**data.tf**
```hcl
data "terraform_remote_state" "base" {
  backend = "s3"

  config = {
    bucket         = "terraform-demo-state-dce2cf761e97"
    key            = "terraform/state/network.tfstate"
    region         = "us-east-1"
    use_lockfile   = true
    encrypt        = true
  }
}
```

## Module Configuration

**ecs-cluster.tf**
```hcl
module "ecs_cluster" {
  source = "../../modules/ecs-cluster"
  ecs_cluster_config = local.ecs_cluster_config
}
```

**locals.tf**
```hcl
locals {
  base_config = data.terraform_remote_state.base.outputs.base_config

  ecs_cluster_config = merge(
    local.base_config,
    {
      ssh_key_name             = "${local.base_config.name_prefix}-bastion-key"
      seed_bucket              = "${local.base_config.name_prefix}-seed-bucket-404008372783"
      tags                     = local.base_config.common_tags
      ecs_execution_role_arn   = ""
      cluster_name_override    = ""
    }
  )
}
```

## Custom Variables

This module primarily consumes configuration from the Base Module Group via remote state. Direct input is typically not required unless overriding defaults.

> [!IMPORTANT]
> In SpaceRocket.Dev demos and examples, this module relies on remote state from the Base Module Group.
> Ensure the base stack is applied successfully before applying this module.
>
> For production environments, review all inherited values carefully and ensure they align with your
> security boundaries, naming standards, and IAM policies.

## Providers

| Name | Version |
|------|---------|
| hashicorp/aws | ~> 6.19 |

## Resources

| Name | Type |
|------|------|
| aws_ecs_cluster | resource |
| aws_ecs_cluster_capacity_providers | resource |
| aws_iam_role | resource |
| aws_iam_role_policy_attachment | resource |
| aws_iam_policy | resource |
| aws_iam_policy_document | data source |
| terraform_remote_state | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| ecs_cluster_config | Composite configuration object derived from the base module outputs and extended with ECS specific settings. Includes naming, IAM, networking references, and secret path prefixes. | object | see variables.tf | No |

## Outputs

| Name | Description |
|------|-------------|
| ecs_cluster_outputs | All ECS cluster primitives grouped into a single object for downstream consumption. |
| ecs_cluster_id | ID of the ECS cluster. |
| ecs_cluster_name | Name of the ECS cluster. |
| ecs_execution_role_arn | ARN of the ECS execution role used by ECS services. |
| ecs_task_role_arn | ARN of the ECS task role intended for application runtime permissions. |
| ecs_task_role_name | Name of the ECS task role. |

## Related Projects

- [01-base](demo/01-base) - 
  Provisions the production ready AWS networking, ingress, DNS, and alerting foundation consumed by this module.

- [03-apps](demo/03-apps) -  
  Provisions and deploys ECS applications on top of the shared base network and ECS cluster, including ALB routing, CI CD, secrets injection, and observability.

> [!TIP]
> #### Use SpaceRocket.Dev Terraform Reference Architectures for AWS
>
> Use SpaceRocket.Dev’s ready to use Terraform reference architectures for AWS to get up and running fast, without sacrificing security, ownership, or clarity.
>
> ✅ We build it side by side with your team.<br/>
> ✅ Your team owns the code and the outcome.<br/>
> ✅ 100% Open Source Terraform with paid, hands on consultancy.<br/>
<br/>
>
> <a href="https://spacerocket.dev"><img alt="Request Quote" src="https://img.shields.io/badge/request%20quote-success.svg?style=for-the-badge"/></a>
>
> <details>
> <summary>📚 <strong>Learn More</strong></summary>
>
> <br/>
>
> SpaceRocket.Dev is a solo DevSecOps consultancy based in San Francisco, focused on helping teams build compliant, production ready AWS platforms using Terraform as the source of truth.
>
> *Your team ships faster, with fewer surprises.*
>
> We combine open source Terraform modules with direct, senior level guidance. The code stays public and reusable. The expertise, context, and execution are delivered through consulting.
>
> #### Day 0: Your Foundation for Success
> - **Reference Architecture.** A complete AWS foundation built from the ground up using Terraform, designed to scale with your product and team.
> - **CI/CD Strategy.** Proven delivery patterns using AWS native tooling, focused on repeatability, auditability, and compliance readiness.
> - **Observability.** Practical visibility into infrastructure and workloads so your team can detect issues early and operate with confidence.
> - **Security Baseline.** Secure by default configurations with guardrails aligned to SOC 2, FedRAMP, NIST 800 53, and Zero Trust principles.
> - **GitOps Workflow.** Infrastructure changes managed through pull requests, reviews, and approvals so nothing happens outside version control.
>
> <a href="https://spacerocket.dev"><img alt="Request Quote" src="https://img.shields.io/badge/request%20quote-success.svg?style=for-the-badge"/></a>
>
> #### Day 2: Operational Confidence
> - **Training.** Clear explanations of how and why the system is built so your team can run it without long term dependency.
> - **Direct Support.** Slack based access to the engineer who built the system, not a ticket queue.
> - **Troubleshooting.** Fast help diagnosing and fixing real world issues when they show up.
> - **Code Reviews.** Practical feedback on Terraform, CI CD, and security changes as your platform evolves.
> - **Bug Fixes.** Hands on remediation when something breaks or needs improvement.
> - **Migration Help.** Guidance and execution support when moving from legacy setups to Terraform driven infrastructure.
> - **Weekly Working Sessions.** Optional workshops to review progress, answer questions, and plan next steps.
>
> <a href="https://spacerocket.dev"><img alt="Request Quote" src="https://img.shields.io/badge/request%20quote-success.svg?style=for-the-badge"/></a>
>
> </details>