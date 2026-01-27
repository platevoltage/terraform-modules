# 03-Prometheus Module Group Demo

This stack deploys **Prometheus on ECS Fargate** with CI/CD, ALB routing, secrets injection (SSM by path), CloudWatch logging, and optional blue green deployments. It is designed to be consumed after the Base and ECS Cluster module demos.

Prometheus is packaged as a container image that includes:

* `prometheus.yml` scrape config
* optional `rules/` (alert rules)
* readiness endpoint `/-/ready` and UI on port `9090`

> [!IMPORTANT]
>
> ### App name must be registered in the base configuration
>
> This demo **assumes the application name is pre-declared** in the Base module configuration.
>
> The `app_name` used by this module **must exist in the `app_names` array** defined in:
>
> ```
> demo/01-base/terraform.tfvars
> ```
>
> For this stack, ensure `prom` is present (example from your base tfvars):
>
> ```
> app_names = ["", "prom", "graf", "cwe", "app1", "hello"]
> ```
>
> If the application name is missing, derived locals such as the SSM path prefix will resolve to `null`, which causes Terraform to fail during plan or apply with errors like:
>
> * Missing required argument for `aws_ssm_parameters_by_path`
> * Invalid template interpolation due to a `null` path prefix

## What This Demo Provisions

* ECS service running Prometheus (rolling by default, optional blue green)
* Target group and ALB listener rule for `prom.<base_domain>`
* KMS encrypted CloudWatch log group (via `modules/ecs-service`)
* CI/CD pipeline (CodePipeline + CodeBuild) to build and deploy the container image
* Encrypted SNS topic for pipeline notifications (KMS CMK + topic policy)

## Prometheus Configuration Notes

The container image includes `app/prom/prometheus.yml`. In your current config, Prometheus scrapes:

* itself (`127.0.0.1:9090` and `localhost:9090`)
* CloudWatch Exporter at `cwe.demo.spacerocket.dev` (HTTPS with `insecure_skip_verify: true`)
* App1 at `app1.demo.spacerocket.dev` (HTTPS with `insecure_skip_verify: true`) and a local target `localhost:9091`

> [!CAUTION]
> `VOLUME ["/prometheus"]` is declared in the Dockerfile. On ECS Fargate, this is **ephemeral unless you add EFS**. For a long lived Prometheus, plan for EFS or a managed metrics backend. This demo focuses on the ECS, routing, and CI/CD patterns.

## Prerequisites

* Base Module Group applied and available via Terraform remote state (`demo/01-base`)
* ECS Cluster Module Group applied and available via Terraform remote state (`demo/02-ecs-cluster`)
* Valid ACM cert ARN for `demo.spacerocket.dev` (or your `base_domain`) and listener 443 in the base stack
* `prom` included in Base `app_names` (see IMPORTANT above)

## Tooling

This demo pins Terraform via `.tool-versions`:

* terraform `1.13.3`

## Inputs

This demo is driven by `terraform.tfvars` in this directory. Typical values:

* `app_name = "prom"`
* `port = 9090`
* `healthcheck_endpoint = "/-/ready"`
* `git_repo = "space-rocket/prometheus"`
* `git_branch = "main"`
* `image_repo = "space-rocket/prod/prometheus"`
* `image_tag = "latest"`
* `priority = 200`
* `deployment_strategy = "rolling"` (default) or `blue_green`

## How To Deploy

From `demo/03-apps/03-prometheus`:

1. Initialize and configure the remote backend:

   * Ensure `backend.hcl` exists locally (it is ignored by git in other app demos)
   * Run:

     * `terraform init -backend-config=backend.hcl`

2. Plan:

   * `terraform plan`

3. Apply:

   * `terraform apply`

## Accessing Prometheus

Once applied, Prometheus should be reachable at:

* `https://prom.<base_domain>`
* Example (from your base tfvars): `https://prom.demo.spacerocket.dev`

Common endpoints:

* `/-/ready` (readiness)
* `/metrics` (Prometheus metrics about Prometheus)
* `/graph` (classic UI)

## AWS Resources

| Name                                            | Type     | Description                                                                                   |
| ----------------------------------------------- | -------- | --------------------------------------------------------------------------------------------- |
| aws_sns_topic.codepipeline_notifications        | resource | SNS topic used for CodePipeline notifications                                                 |
| aws_sns_topic_policy.default                    | resource | Allows CodeStar Notifications to publish to the application SNS topic                         |
| aws_kms_key.sns_topic                           | resource | Customer managed KMS key used to encrypt the SNS topic                                        |
| aws_kms_alias.sns_topic                         | resource | Alias for the SNS KMS key                                                                     |
| aws_lb_listener.test_8080                       | resource | HTTPS test listener used for CodeDeploy blue green test traffic (when enabled)                |
| module.target_group                             | module   | ALB target group for Prometheus (blue)                                                        |
| module.target_group_green                       | module   | Optional target group for green traffic (blue green only)                                     |
| module.ecs_service                              | module   | ECS service + task definition + security group + log group (rolling or CodeDeploy controlled) |
| module.codepipeline                             | module   | CodePipeline + CodeBuild projects + artifact buckets + IAM roles                              |
| aws_codedeploy_app.ecs                          | resource | CodeDeploy application (blue green only, created inside `modules/ecs-service`)                |
| aws_codedeploy_deployment_group.ecs             | resource | CodeDeploy deployment group managing traffic shifting (blue green only)                       |
| aws_iam_role.codedeploy                         | resource | IAM role assumed by CodeDeploy (blue green only, inside `modules/ecs-service`)                |
| aws_iam_role.ecs_task_role                      | resource | IAM role assumed by the ECS task (inside `modules/ecs-service`)                               |
| aws_iam_policy.ecs_exec_policy                  | resource | Policy enabling ECS Exec support (inside `modules/ecs-service`)                               |
| aws_cloudwatch_log_group.fargate_task_log_group | resource | KMS encrypted CloudWatch log group for container logs (inside `modules/ecs-service`)          |
| aws_kms_key.cloudwatch_logs                     | resource | KMS key used to encrypt CloudWatch Logs (inside `modules/ecs-service`)                        |

## Data Sources

| Name                                            | Type        | Description                                                               |
| ----------------------------------------------- | ----------- | ------------------------------------------------------------------------- |
| data.aws_caller_identity.current                | data source | Retrieves the AWS account ID at runtime                                   |
| data.aws_ssm_parameters_by_path.all_app_secrets | data source | Loads application secrets from SSM Parameter Store by derived path prefix |
| data.terraform_remote_state.base                | data source | Consumes outputs from the Base Module Group                               |
| data.terraform_remote_state.ecs_cluster         | data source | Consumes outputs from the ECS Cluster Module                              |

## Outputs

This demo is intended to expose the same style of structured outputs used by other app stacks (for example `01-app1`), including values like URL, log group, task definition metadata, and target group identifiers.

If you add an `outputs.tf` for this stack, recommended outputs to include are:

| Name                    | Description                                                                  |
| ----------------------- | ---------------------------------------------------------------------------- |
| app_name                | Logical application name used for naming and routing.                        |
| app_port                | Container port exposed by Prometheus (9090).                                 |
| deployment_strategy     | Deployment strategy for the ECS service (rolling or blue_green).             |
| healthcheck_endpoint    | Health endpoint used by ALB and ECS health checks (`/-/ready`).              |
| app_url                 | Primary HTTPS URL for Prometheus (`https://prom.<base_domain>`).             |
| app_host_header         | Host header used by the ALB listener rule (`prom.<base_domain>`).            |
| log_group_name          | CloudWatch Logs group name used for ECS task and pipeline logs.              |
| path_prefix             | Base path prefix resolved from `base_outputs.path_prefix_map` for this app.  |
| ssm_secret_path_prefix  | SSM Parameter Store secret path prefix resolved from base outputs.           |
| ecs_cluster_id          | ECS cluster id from remote state.                                            |
| ecs_cluster_name        | ECS cluster name from remote state.                                          |
| ecs_service_name        | ECS service name created for this app (rolling or blue_green).               |
| ecs_task_definition_arn | ECS task definition ARN for the app.                                         |
| ecs_task_role_name      | IAM role name assumed by the ECS task.                                       |
| target_group_blue_arn   | Target group ARN used for production traffic (blue).                         |
| target_group_green_arn  | Target group ARN used for green traffic (blue green only).                   |
| prod_listener_arn       | ALB HTTPS listener ARN used for production traffic routing.                  |
| test_listener_arn       | ALB HTTPS test listener ARN used for blue green test traffic (when enabled). |
| git_repo                | GitHub repository used by the pipeline source action.                        |
| git_branch              | Git branch used by the pipeline source action.                               |
| image_repo              | ECR repository name used by the build (repo path only, no registry).         |
| image_tag               | Image tag input used by the service config.                                  |

## Related Projects

* [01-base](../01-base)
  Provides the shared VPC, ALB, DNS, certificates, logging, and alerting foundation.

* [02-ecs-cluster](../02-ecs-cluster)
  Provisions the shared ECS cluster, capacity providers, and IAM roles consumed by this application.

* [01-app1](../01-app1)
  Example app that exposes `/metrics` and is scraped by Prometheus in this demo.

> [!TIP]
>
> #### Use SpaceRocket.Dev Terraform Reference Architectures for AWS
>
> Use SpaceRocket.Dev’s ready to use Terraform reference architectures for AWS to get up and running fast, without sacrificing security, ownership, or clarity.
>
> ✅ Side by side implementation of this module in your AWS account with your team.<br/>
> ✅ Your team owns the code and the outcome.<br/>
> ✅ 100% Open Source Terraform with paid, hands on consultancy.<br/>
>
> <a href="https://spacerocket.dev"><img alt="Request Quote" src="https://img.shields.io/badge/request%20quote-success.svg?style=for-the-badge"/></a>
>
> <details>
> <summary>📚 <strong>Learn More</strong></summary>
>
> <br/>
>
> SpaceRocket.Dev is a solo DevSecOps consultancy based in San Francisco, focused on helping teams build secure, compliant, production ready AWS platforms using Terraform as the source of truth.
>
> *Your team ships faster, with fewer surprises.*
>
> We combine open source Terraform modules with direct, senior level guidance. The code stays public and reusable. The expertise, context, and execution are delivered through consulting.
>
> #### Foundation for Production
>
> * **Reference Architecture.** A complete AWS foundation built using Terraform, designed to scale with your product and team.
> * **CI/CD Strategy.** Proven delivery patterns using AWS native tooling, focused on repeatability, auditability, and compliance readiness.
> * **Observability.** Practical visibility into infrastructure and workloads so issues are detected early and teams operate with confidence.
> * **Security Baseline.** Secure by default configurations aligned with SOC 2, FedRAMP, NIST 800 53, and Zero Trust principles.
> * **GitOps Workflow.** Infrastructure changes managed through pull requests, reviews, and approvals so everything stays in version control.
>
> <a href="https://spacerocket.dev"><img alt="Request Quote" src="https://img.shields.io/badge/request%20quote-success.svg?style=for-the-badge"/></a>
>
> #### Ongoing Operational Support
>
> * **Training.** Clear explanations of how and why the system is built so your team can run it independently.
> * **Direct Support.** Slack based access to the engineer who implemented the platform.
> * **Troubleshooting.** Fast help diagnosing and resolving real world issues.
> * **Code Reviews.** Practical feedback on Terraform, CI/CD, and security changes as your platform evolves.
> * **Bug Fixes.** Hands on remediation when improvements or fixes are needed.
> * **Migration Support.** Guidance and execution help when moving from legacy setups to Terraform driven infrastructure.
> * **Weekly Working Sessions.** Optional live sessions to review progress, answer questions, and plan next steps.
>
> <a href="https://spacerocket.dev"><img alt="Request Quote" src="https://img.shields.io/badge/request%20quote-success.svg?style=for-the-badge"/></a>
>
> </details>
