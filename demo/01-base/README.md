# Base Module Group Demo

**Module Group** to provision a production-ready AWS networking and application ingress foundation.

This Module Group provisions a fully configured AWS VPC, Application Load Balancer, ACM certificates, and alerting infrastructure. It is designed to serve as the foundational layer for compliant, internet-facing workloads, providing secure networking, HTTPS ingress, DNS aliasing, access logging, and operational alarms. Ideal for teams building ECS, EKS, or other AWS-native application platforms that require a repeatable, auditable, and production-grade infrastructure baseline.

## What This Module Provisions

This Module Group provisions the following resources:
- A fully configured AWS VPC with public and private subnets spanning multiple Availability Zones, including NAT gateway support.
- An internet-facing Application Load Balancer with HTTPS listeners, modern TLS security policies, access logging, and health checks.
- ACM certificate integration for primary and additional domains to enable TLS termination.
- Route53 alias records for application domains and subdomains.
- CloudWatch alarms and SNS topics for load balancer and target health alerting.
- Shared outputs intended for consumption by downstream ECS, EKS, or other AWS native application modules.

## Prerequisites
- Terraform state bucket, ex: `terraform-demo-state-example-123456789`. Note S3 buckets names are global, so make sure its unique. 
- Terraform state lock Dynamo DB table created, ex: `terraform-state-locks-example`
- Domain name with ACM certificate created.


## Usage

### Backend Configuration

Configure Terraform backend state file:
**backends.tf**
```hcl
bucket         = "terraform-demo-state-example-123456789"
key            = "terraform/state/network.tfstate"
region         = "us-east-1"
dynamodb_table = "terraform-state-locks-example"
```

### Custom Variables

These variables are required to be passed in:
- `admin_email`
- `base_domain`
- `env`
- `org`
- `project`
- `aws_region`
- `allowed_ips`
- `app_names`
- `natgw_count`
- `cert_arn`
- `additional_cert_arn`

#### Example .tfvars file:

**terraform.tfvars**
```hcl
admin_email         = "admin@spacerocket.dev"
base_domain         = "demo.spacerocket.dev"
env                 = "dev"
org                 = "example"
project             = "demo-proj" # keep limited to 9 characters
aws_region          = "us-east-1"
allowed_ips         = ["203.0.113.10"] # your IP or VPN address
app_names           = ["", "prom", "graf", "cwe", "hello"]
natgw_count         = "one"
cert_arn            = "arn:aws:acm:us-east-1:123456789012:certificate/00000000-0000-0000-0000-000000000000"
additional_cert_arn = "arn:aws:acm:us-east-1:123456789012:certificate/00000000-0000-0000-0000-000000000000"
```

> [!IMPORTANT]
> In SpaceRocket.Dev demos and examples, we use the `spacerocket.dev` domain for illustration purposes only.
> You must replace this with a domain that you own and control before applying any infrastructure.
>
> Using a domain you do not own can cause certificate validation failures, DNS errors, and unintended conflicts.
> Always configure Route53 zones, ACM certificates, and DNS records against your own domain in real environments.



```bash

```

> [!IMPORTANT]
> In SpaceRocket.Dev’s demos, we avoid pinning modules to specific versions to reduce the risk of documentation drifting from the most recent releases.
> However, for your own projects, we strongly recommend pinning each module to the exact version in use.
> This helps maintain infrastructure stability.
> We also suggest adopting a consistent process for managing and updating versions to prevent unexpected changes.

> [!IMPORTANT]
> This repository derives the AWS account ID at runtime using `data.aws_caller_identity.current.account_id`.
> We do this to keep the demo and examples portable across accounts without requiring `var.account_id`.
>
> For production, we recommend using a static, explicitly managed mapping for any account specific values that influence
> security policy, ARNs, or trust boundaries (for example, cross account IAM/KMS policies, allowlists, or organization
> guardrails). This avoids accidental drift when running the same code across multiple accounts and environments.

**identity.tf**
```tf
data "aws_caller_identity" "current" {}

locals {
  account_id = data.aws_caller_identity.current.account_id
}
```

## Providers

| Name | Version |
|------|---------|
| [hashicorp/aws](https://registry.terraform.io/providers/hashicorp/aws/latest) | ~> 6.19 |
| [hashicorp/time](https://registry.terraform.io/providers/hashicorp/time/latest) | ~> 0.11 |

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_cloudwatch_metric_alarm](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_default_security_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/default_security_group) | resource |
| [aws_eip](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip) | resource |
| [aws_flow_log](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/flow_log) | resource |
| [aws_iam_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_internet_gateway](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway) | resource |
| [aws_kms_alias](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias) | resource |
| [aws_kms_key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_lb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb) | resource |
| [aws_lb_listener](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener) | resource |
| [aws_nat_gateway](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/nat_gateway) | resource |
| [aws_route](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route53_record](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_route_table](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table_association](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_s3_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_lifecycle_configuration](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_lifecycle_configuration) | resource
| [aws_availability_zones](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/availability_zones) | data source |
| [aws_caller_identity](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_route53_zone](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route53_zone) | data source |

## Inputs

| Name                  | Description                                                                                                                                                                   | Type           | Default                | Required |
|-----------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|----------------|------------------------|----------|
| env                   | Deployment environment identifier such as dev, staging, or prod. Used in name_prefix, tags, log prefixes, DNS records, and SSM path construction.                            | string         | "dev"                  | No       |
| org                   | Organization or tenant identifier used to build name_prefix values and hierarchical paths of the form org/project/env.                                                     | string         | "example"              | No       |
| project               | Project identifier used in resource names, tags, logs bucket naming, routing, and SSM path construction.                                                                    | string         | "demo"                 | No       |
| admin_email           | Email address subscribed to the SNS alerts topic for CloudWatch alarms, including ALB and target 5xx alarms.                                                                | string         | "admin@example.com"    | No       |
| aws_region            | AWS region to deploy resources into. Used for provider configuration, regional ARNs, and region specific service behavior.                                                  | string         | "us-east-1"             | No       |
| cert_arn              | ACM certificate ARN used by the ALB HTTPS listener as the primary TLS certificate.                                                                                            | string         | ""                     | No       |
| additional_cert_arn   | Additional ACM certificate ARN reserved for future or optional use. Not currently passed into the ALB module configuration.                                                 | string         | ""                     | No       |
| allowed_ips           | List of IPv4 addresses or CIDR ranges allowed to access the public ALB. Plain IPs are automatically normalized to /32 when generating security group rules.                 | list(string)   | ["0.0.0.0/0"]          | No       |
| app_names             | List of application subdomain prefixes used to generate FQDNs, Route53 alias records, and per application SSM and path prefixes. An empty string represents the root domain. | list(string)   | ["", "app"]            | No       |
| base_domain            | Base DNS domain hosted in Route53. Used to construct application FQDNs and create ALB alias records.                                                                          | string         | "example.com"          | No       |
| natgw_count            | NAT Gateway strategy for the VPC. Supported values are none, one, or all. Controls how many NAT gateways are created and which NAT EIPs are allow listed on the ALB.         | string         | "one"                  | No       |

## Outputs

| Name | Description |
|------|-------------|
| `account_id` | AWS account ID for the deployment. In demos this is derived at runtime for portability; for production prefer an explicitly managed static mapping for any account-specific values. |
| `base_domain` | Base DNS domain for the environment used to derive main_domain and fqdn_map. |
| `project` | Project identifier used for naming and tagging across the stack. |
| `project_name` | Derived project name in the form `<project>-<env>` used for consistent naming. |
| `name_prefix` | Shared name prefix used for naming resources and app task names in downstream modules. |
| `env` | Environment name such as dev, stage, or prod. Used for naming, logs prefixing, and tags. |
| `aws_region` | AWS region used by base and downstream stacks. |
| `region` | Alias of aws_region for downstream compatibility. |
| `admin_email` | Administrative email address used for alerting and notifications. |
| `allowed_ips` | Allowlist of public IPs or CIDRs used to restrict access where applicable. |
| `natgw_count` | NAT gateway sizing selector passed into the network module that controls the number of NAT gateways. |
| `common_tags` | Standard tags applied across resources and merged into downstream stacks. |
| `lb_ssl_policy` | ALB TLS policy name used by listeners and referenced by downstream test listeners. |
| `main_domain` | Primary domain name used by the ALB and DNS records, typically equal to base_domain. |
| `additional_domains` | Additional domain names to include on the ALB certificate and or DNS aliases. |
| `fqdn_map` | Map of logical names to fully qualified domain names used by downstream stacks. |
| `logs_enabled` | Whether ALB access logging is enabled for the environment. |
| `logs_prefix` | S3 log prefix for ALB access logs, commonly set to env. |
| `logs_bucket` | S3 bucket name used for ALB access logs. |
| `logs_expiration` | S3 lifecycle expiration in days for access log objects. |
| `logs_bucket_force_destroy` | Whether the logs bucket may be force destroyed, generally false for safety. |
| `alb_5xx_threshold` | Threshold for ALB HTTP 5xx alarms. |
| `target_5xx_threshold` | Threshold for target HTTP 5xx alarms. |
| `topic_name` | SNS topic name used by the base alerts topic. |
| `path_prefixes` | List of per app ALB path prefixes used by downstream stacks for routing and naming. |
| `ssm_secret_path_prefixes` | List of per app SSM parameter path prefixes used by downstream stacks to locate secrets. |
| `cert_arn` | ACM certificate ARN used by the ALB listeners and downstream test listeners. |
| `vpc_id` | VPC ID for the environment consumed by downstream stacks. |
| `public_subnet_ids` | Public subnet IDs created by the base network module. |
| `private_subnet_ids` | Private subnet IDs created by the base network module and used for Fargate tasks downstream. |
| `alb_listener_443_arn` | ARN of the ALB HTTPS 443 listener used by downstream ECS services. |
| `alb_arn_suffix` | ALB ARN suffix used for CloudWatch metrics and alarms. |
| `alb_dns_name` | ALB DNS name used for DNS aliasing and validation. |
| `alb_arn` | ALB ARN used by downstream resources such as test listeners. |
| `alb_sg_id` | Security group ID attached to the ALB and referenced by downstream stacks. |
| `alarm_sns_topic_arn` | SNS topic ARN used for base alarms and notifications. |
| `sns_topic_arn` | Alias of alarm_sns_topic_arn for downstream compatibility. |
| `sns_topic_name` | SNS topic name used for base alerts and downstream integrations. |
| `app_names` | List of application identifiers used to build routing and secret path maps. |
| `ssm_secret_path_prefix_map` | Map of app name to SSM parameter path prefix used by downstream stacks to resolve per app secret locations. |
| `path_prefix_map` | Map of app name to normalized ALB path prefix with trailing slash removed used by downstream ECS services. |

## Related Projects

Check out these related projects.

- [02-ecs-cluster](demo/02-ecs-cluster) - ecs-cluster provisions a production ready Amazon ECS cluster that serves as the shared compute foundation for application workloads, including capacity providers, cluster level logging and insights, IAM roles, and baseline configuration designed to be consumed by downstream app and service modules.
- [03-apps](demo/03-apps) - apps provisions and deploys production ready ECS applications on top of the shared base network and ECS cluster, including CI/CD pipelines, ALB routing, secrets injection, observability, and optional blue green or rolling deployment strategies.

> [!TIP]
> #### Use SpaceRocket.Dev Terraform Reference Architectures for AWS
>
> Use SpaceRocket.Dev’s ready to use Terraform reference architectures for AWS to get up and running fast, without sacrificing security, ownership, or clarity.
>
> ✅ We build it side by side with your team.<br/>
> ✅ Your team owns the code and the outcome.<br/>
> ✅ 100% Open Source Terraform with paid, hands on consultancy.<br/>
> ✅ Optional YouTube walkthroughs explaining the architecture and code.<br/>
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
