# Hello World

> [!IMPORTANT]
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
> If the application name is missing, derived locals such as the SSM path prefix will resolve to `null`, which causes Terraform to fail during plan or apply with errors like:
>
> - Missing required argument for `aws_ssm_parameters_by_path`
> - Invalid template interpolation due to a `null` path prefix
>
> **Before running this demo**, ensure the application name is explicitly listed in the base configuration so all downstream paths, log groups, and secrets can be resolved correctly.

### AWS Resources

| Name | Type | Description |
|-----|-----|-------------|
| aws_sns_topic.codepipeline_notifications | resource | SNS topic used for CodePipeline and deployment notifications |
| aws_sns_topic_policy.default | resource | Allows CodeStar Notifications to publish to the application SNS topic |
| aws_kms_key.sns_topic | resource | Customer managed KMS key used to encrypt the SNS topic |
| aws_kms_alias.sns_topic | resource | Alias for the SNS KMS key |
| aws_lb_listener.test_8080 | resource | HTTPS test listener used for CodeDeploy blue green test traffic |
| aws_ecs_task_definition.app | resource | ECS task definition for the Hello World application |
| aws_ecs_service.ecs_app_service_rolling | resource | ECS service used for rolling deployments |
| aws_ecs_service.ecs_app_service_codedeploy | resource | ECS service controlled by CodeDeploy for blue green deployments |
| aws_cloudwatch_log_group.fargate_task_log_group | resource | KMS encrypted CloudWatch log group for application logs |
| aws_kms_key.cloudwatch_logs | resource | KMS key used to encrypt CloudWatch Logs |
| aws_kms_alias.cloudwatch_logs | resource | Alias for the CloudWatch Logs KMS key |
| aws_security_group.ecs_fargate_task | resource | Security group attached to the Fargate task |
| aws_security_group_rule.from_alb_to_task | resource | Allows ALB to reach the application container port |
| aws_security_group_rule.ecs_fargate_task_egress | resource | Allows outbound IPv4 traffic from the ECS task |
| aws_security_group_rule.ecs_fargate_task_egress_v6 | resource | Allows outbound IPv6 traffic from the ECS task |
| aws_codedeploy_app.ecs | resource | CodeDeploy application for ECS deployments |
| aws_codedeploy_deployment_group.ecs | resource | CodeDeploy deployment group managing traffic shifting |
| aws_iam_role.codedeploy | resource | IAM role assumed by CodeDeploy |
| aws_iam_role_policy_attachment.codedeploy_managed | resource | Attaches AWS managed CodeDeploy ECS policy |
| aws_iam_role.ecs_task_role | resource | IAM role assumed by the ECS task |
| aws_iam_policy.ecs_exec_policy | resource | Policy enabling ECS Exec support |
| aws_iam_role_policy_attachment.ecs_exec_policy_attachment | resource | Attaches ECS Exec policy to the task role |
| aws_iam_policy.secrets_manager_policy | resource | Optional policy allowing Secrets Manager access |
| aws_iam_role_policy_attachment.secrets_manager_policy_attachment | resource | Attaches Secrets Manager policy to the task role |
| aws_iam_policy.sqs_policy | resource | Optional policy allowing SQS access |
| aws_iam_role_policy_attachment.sqs_policy_attachment | resource | Attaches SQS policy to the task role |
| aws_cloudwatch_metric_alarm.unhealthy_instance_count | resource | Alarm triggered when ALB target group reports unhealthy tasks |

## Data Sources

| Name | Type | Description |
|-----|-----|-------------|
| data.aws_caller_identity.current | data source | Retrieves the AWS account ID at runtime |
| data.aws_ssm_parameters_by_path.all_app_secrets | data source | Loads application secrets from SSM Parameter Store |
| data.terraform_remote_state.base | data source | Consumes outputs from the Base Module Group |
| data.terraform_remote_state.ecs_cluster | data source | Consumes outputs from the ECS Cluster Module |

## Outputs

| Name | Description |
|------|-------------|
| app_name | Logical application name used for naming and resource scoping. |
| app_port | Container port exposed by the application. |
| deployment_strategy | Deployment strategy for the ECS service (rolling or blue_green). |
| healthcheck_endpoint | HTTP healthcheck endpoint used by ALB and ECS health checks. |
| app_url | Primary HTTPS URL for the app when root domain is configured in base remote state. |
| app_host_header | Host header used by the ALB listener rule for routing. |
| log_group_name | CloudWatch Logs group name used for ECS task and pipeline logs. |
| path_prefix | Base path prefix resolved from base_outputs.path_prefix_map for this app. |
| ssm_secret_path_prefix | SSM Parameter Store secret path prefix resolved from base outputs. |
| sns_topic_arn | SNS topic ARN for CodePipeline and deployment notifications. |
| sns_kms_key_arn | KMS key ARN used to encrypt the SNS topic. |
| sns_kms_alias | KMS alias name used for the SNS topic key. |
| ecs_cluster_id | ECS cluster id from remote state. |
| ecs_cluster_name | ECS cluster name from remote state. |
| ecs_service_name | ECS service name created for this app (rolling or blue_green). |
| ecs_task_definition_arn | ECS task definition ARN for the app. |
| ecs_task_role_name | IAM role name assumed by the ECS task. |
| ecs_task_definition_family | ECS task definition family for the app. |
| ecs_task_definition_revision | ECS task definition revision number for the app. |
| task_name | Task or service name prefix used across resources. |
| app_image | Full ECR image reference used by the ECS task definition. |
| target_group_blue_arn | Target group ARN used for production traffic (blue). |
| target_group_blue_name | Target group name used for production traffic (blue). |
| target_group_green_arn | Target group ARN used for green traffic when deployment_strategy is blue_green. |
| target_group_green_name | Target group name used for green traffic when deployment_strategy is blue_green. |
| prod_listener_arn | ALB HTTPS listener ARN used for production traffic routing. |
| test_listener_arn | ALB HTTPS test listener ARN used by CodeDeploy for blue_green test traffic. |
| codedeploy_app_name | CodeDeploy application name when deployment_strategy is blue_green. |
| codedeploy_deployment_group_name | CodeDeploy deployment group name when deployment_strategy is blue_green. |
| git_repo | GitHub repository used by the pipeline source action. |
| git_branch | Git branch used by the pipeline source action. |
| image_repo | ECR repository name used by the build (repo path only, no registry). |
| image_tag | Image tag input used by the service config. |

## Related Projects

- [01-base](../01-base)  
  Provides the shared VPC, ALB, DNS, certificates, logging, and alerting foundation.

- [02-ecs-cluster](../02-ecs-cluster)  
  Provisions the shared ECS cluster, capacity providers, and IAM roles consumed by this application.

> [!TIP]
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
> - **Reference Architecture.** A complete AWS foundation built using Terraform, designed to scale with your product and team.
> - **CI/CD Strategy.** Proven delivery patterns using AWS native tooling, focused on repeatability, auditability, and compliance readiness.
> - **Observability.** Practical visibility into infrastructure and workloads so issues are detected early and teams operate with confidence.
> - **Security Baseline.** Secure by default configurations aligned with SOC 2, FedRAMP, NIST 800 53, and Zero Trust principles.
> - **GitOps Workflow.** Infrastructure changes managed through pull requests, reviews, and approvals so everything stays in version control.
>
> <a href="https://spacerocket.dev"><img alt="Request Quote" src="https://img.shields.io/badge/request%20quote-success.svg?style=for-the-badge"/></a>
>
> #### Ongoing Operational Support
> - **Training.** Clear explanations of how and why the system is built so your team can run it independently.
> - **Direct Support.** Slack based access to the engineer who implemented the platform.
> - **Troubleshooting.** Fast help diagnosing and resolving real world issues.
> - **Code Reviews.** Practical feedback on Terraform, CI/CD, and security changes as your platform evolves.
> - **Bug Fixes.** Hands on remediation when improvements or fixes are needed.
> - **Migration Support.** Guidance and execution help when moving from legacy setups to Terraform driven infrastructure.
> - **Weekly Working Sessions.** Optional live sessions to review progress, answer questions, and plan next steps.
>
> <a href="https://spacerocket.dev"><img alt="Request Quote" src="https://img.shields.io/badge/request%20quote-success.svg?style=for-the-badge"/></a>
>
> </details>
