# ALB Module

Terraform module that provisions a production ready **public Application Load Balancer (ALB)** for ECS/Fargate workloads, including:

- HTTP to HTTPS redirect
- HTTPS listener with a primary ACM certificate
- Security group rules (public allowlist plus optional NAT Gateway EIPs)
- ALB access logging to S3 (AES256, per ALB requirements) plus optional server access logging for that bucket
- CloudWatch alarms for ALB 5xx and target 5xx wired to an SNS topic
- Optional Route53 alias records for multiple hostnames

This module is intended to be consumed by a higher level stack that provides the VPC/subnets and app routing (listener rules + target groups), such as your base or app stacks.

## What This Module Provisions

- `aws_lb` Application Load Balancer (internet-facing, dualstack, HTTP/2 enabled)
- Listener `:80` that redirects to `:443`
- Listener `:443` with `lb_ssl_policy` and a primary ACM certificate
- ALB Security Group:
  - Ingress `80`, `443`, and `8080` from `network_config.public_ips` (and IPv6 equivalents from `public_ips_v6`)
  - Optional ingress `80` and `443` from NAT Gateway EIPs (useful for internal callers that egress via NAT)
  - Egress allow all
- S3 bucket for ALB access logs (AES256) plus:
  - Lifecycle expiration for log objects
  - Bucket policy for ELB log delivery service
  - Public access block + ownership controls
  - Optional server access logging for the logs bucket into a separate access bucket
- KMS key and alias used for S3 server access logs bucket encryption (not the ALB destination bucket)
- CloudWatch alarms:
  - `HTTPCode_ELB_5XX_Count`
  - `HTTPCode_Target_5XX_Count`

## Usage

### Example

```hcl
module "alb" {
  source = "./modules/alb"

  network_config = local.network_config

  alb_config = {
    account_id               = local.base_config.account_id
    env                      = local.base_config.env
    project                  = local.base_config.project
    name_prefix              = local.base_config.name_prefix
    aws_region               = local.base_config.aws_region

    vpc                      = module.network.vpc
    lb_subnets               = module.network.subnets_public

    # Listener TLS policy and cert
    lb_ssl_policy            = "ELBSecurityPolicy-TLS13-1-3-FIPS-2023-04"
    main_cert_arn            = var.cert_arn

    # Domains and optional Route53 aliases
    main_domain              = var.base_domain
    additional_domains       = values(local.fqdn_map)
    create_aliases = [
      for app, fqdn in local.fqdn_map : {
        name = fqdn
        zone = var.base_domain
      }
    ]

    # Access logs destination bucket (ALB requires SSE-S3 / AES256)
    logs_enabled             = true
    logs_prefix              = var.env
    logs_bucket              = local.logs_bucket
    logs_expiration          = 90
    logs_bucket_force_destroy = false

    # Optional NAT EIPs allowlist (if callers egress via NAT)
    nat_gateway_eips         = module.network.nat_gateway_eips

    # Alarm wiring
    alb_5xx_threshold        = 20
    target_5xx_threshold     = 20
    alarm_sns_topic_arn      = module.sns_dev_alerts.topic_arn

    # Optional: server access logging for the logs bucket
    logs_access_enabled      = true
    logs_access_bucket       = null
    logs_access_prefix       = "s3-access-logs/"
    logs_access_expiration   = 365
    logs_access_bucket_force_destroy = false

    # Safety
    enable_deletion_protection = true

    common_tags = local.base_config.common_tags
  }
}
```

## Inputs

This module is configured using two object inputs: `alb_config` and `network_config`.

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| alb_config | Composite config for ALB, logging, Route53 aliases, and alarms. | object | see `variables.tf` | No |
| network_config | Network context used for naming, tags, allowlists, and NAT sizing. | object | see `variables.tf` | No |

---

## alb_config schema

| Field | Description | Type | Required |
|------|-------------|------|----------|
| env | Environment name (dev, stage, prod, etc.). | string | yes |
| project | Project identifier used for naming and tagging. | string | yes |
| name_prefix | Name prefix used for ALB and SG names. | string | yes |
| aws_region | AWS region for region-scoped behavior (log delivery account mapping). | string | yes |
| vpc | VPC object (expects `.id`). | any | yes |
| lb_subnets | Subnet objects for ALB attachment (expects `[*].id`). | list(any) | yes |
| lb_ssl_policy | ALB TLS policy name for the HTTPS listener. | string | yes |
| main_domain | Primary domain name for this environment (informational). | string | yes |
| additional_domains | Additional domains (informational; module does not create extra certs). | list(string) | yes |
| logs_enabled | Whether ALB access logging is enabled. | bool | yes |
| logs_prefix | S3 prefix for ALB access logs. | string | yes |
| logs_bucket | S3 bucket name for ALB access logs (AES256). | string | yes |
| logs_expiration | Lifecycle expiration (days) for ALB access log objects. | number | yes |
| logs_bucket_force_destroy | Whether to force destroy the logs bucket. | bool | yes |
| main_cert_arn | ACM cert ARN for the HTTPS listener. | string | yes |
| create_aliases | Route53 alias records to create. | list(object({ name=string, zone=string })) | yes |
| common_tags | Tags applied to supported resources. | map(string) | yes |
| alarm_sns_topic_arn | SNS topic ARN for alarm actions. | string | yes |
| alb_5xx_threshold | Threshold for ALB HTTP 5xx alarm. | number | no |
| target_5xx_threshold | Threshold for target HTTP 5xx alarm. | number | no |
| account_id | AWS account id (used for log delivery and KMS policies). | string | no |
| logs_access_enabled | Enable server access logging for the ALB logs bucket. | bool | no |
| logs_access_bucket | Existing bucket for server access logs. | string | no |
| logs_access_prefix | Prefix for server access log objects. | string | no |
| logs_access_bucket_force_destroy | Force destroy server access logs bucket. | bool | no |
| logs_access_expiration | Lifecycle expiration (days) for server access logs. | number | no |
| nat_gateway_eips | NAT gateway public IPs allowed on 80/443. | list(string) | no |
| logs_kms_key_arn | Reserved for future use. | string | no |
| enable_deletion_protection | Enable ALB deletion protection. | bool | no |
| lb_sg | Reserved/deprecated (module creates its own SG). | any | yes |

> [!NOTE]  
> The ALB access logs destination bucket must use **SSE-S3 (AES256)**.  
> An optional separate bucket can be created for **server access logs**, which may be KMS-encrypted, to audit access to the ALB logs bucket itself.

---

## network_config schema

| Field | Description | Type | Required |
|------|-------------|------|----------|
| project_name | Display name used in Name tags. | string | yes |
| name_prefix | Shared prefix for naming ALB, SG, and KMS alias. | string | yes |
| base_domain | Base DNS domain. | string | yes |
| account_id | AWS account id (informational). | string | yes |
| env | Environment name (dev, stage, prod, etc.). | string | yes |
| project | Project identifier. | string | yes |
| aws_region | AWS region. | string | yes |
| az_num | Number of AZs (used for NAT sizing). | number | yes |
| natgw_count | NAT strategy: `none`, `one`, `all`. | string | yes |
| public_ips | IPv4 CIDR allowlist for ALB ingress. | map(string) | yes |
| public_ips_v6 | IPv6 CIDR allowlist for ALB ingress. | map(string) | yes |
| app_ports | Application ports (informational). | list(number) | yes |
| common_tags | Standard tags. | map(string) | yes |
| vpc_ip_block | VPC CIDR (informational). | string | yes |
| subnet_cidr_private | Private subnet CIDR base. | string | yes |
| subnet_cidr_public | Public subnet CIDR base. | string | yes |
| new_bits_private | CIDR subdivision bits for private subnets. | number | yes |
| new_bits_public | CIDR subdivision bits for public subnets. | number | yes |

---

## Outputs

| Name | Description |
|------|-------------|
| alb_dns_name | DNS name of the ALB. |
| alb_arn | ARN of the ALB. |
| arn_suffix | ARN suffix of the ALB (CloudWatch dimension). |
| listener_443_arn | ARN of the HTTPS (443) listener. |
| alb_sg_id | Security group id attached to the ALB. |
| alias_zones_debug | Debug output of alias zones derived from `create_aliases`. |

---

## Resources

| Name | Type | Description |
|------|------|-------------|
| aws_lb.this | resource | Public application load balancer (dualstack). |
| aws_lb_listener.default_80 | resource | HTTP listener redirecting to HTTPS. |
| aws_lb_listener.default_app_443 | resource | HTTPS listener with TLS policy and cert. |
| aws_security_group.alb | resource | ALB security group. |
| aws_security_group_rule.alb_egress | resource | ALB egress allow all (IPv4). |
| aws_security_group_rule.alb_egress_v6 | resource | ALB egress allow all (IPv6). |
| aws_security_group_rule.alb_80 | resource | Ingress 80 from IPv4 allowlist. |
| aws_security_group_rule.alb_443 | resource | Ingress 443 from IPv4 allowlist. |
| aws_security_group_rule.alb_8080 | resource | Ingress 8080 from IPv4 allowlist. |
| aws_security_group_rule.alb_80_v6 | resource | Ingress 80 from IPv6 allowlist. |
| aws_security_group_rule.alb_443_v6 | resource | Ingress 443 from IPv6 allowlist. |
| aws_security_group_rule.alb_8080_v6 | resource | Ingress 8080 from IPv6 allowlist. |
| aws_security_group_rule.alb_80_nat_eips | resource | Ingress 80 from NAT gateway EIPs. |
| aws_security_group_rule.alb_443_nat_eips | resource | Ingress 443 from NAT gateway EIPs. |
| aws_s3_bucket.logs | resource | ALB access logs bucket (AES256). |
| aws_s3_bucket_policy.alb_logs | resource | ELB log delivery bucket policy. |
| aws_s3_bucket_public_access_block.logs | resource | Public access block for logs bucket. |
| aws_s3_bucket_server_side_encryption_configuration.logs | resource | SSE-S3 config for logs bucket. |
| aws_s3_bucket_ownership_controls.logs | resource | Bucket ownership controls. |
| aws_s3_bucket_versioning.logs | resource | Versioning for logs bucket. |
| aws_s3_bucket_lifecycle_configuration.logs | resource | Lifecycle expiration for logs. |
| aws_s3_bucket_logging.logs | resource | Server access logging for logs bucket. |
| aws_s3_bucket.logs_access | resource | Optional access-logs bucket (KMS). |
| aws_s3_bucket_policy.logs_access | resource | Policy for S3 server access logs. |
| aws_s3_bucket_public_access_block.logs_access | resource | Public access block (access logs). |
| aws_s3_bucket_server_side_encryption_configuration.logs_access | resource | KMS encryption for access logs. |
| aws_s3_bucket_lifecycle_configuration.logs_access | resource | Lifecycle expiration for access logs. |
| aws_s3_bucket_notification.logs_eventbridge | resource | EventBridge notifications (logs). |
| aws_s3_bucket_notification.logs_access_eventbridge | resource | EventBridge notifications (access logs). |
| aws_kms_key.alb_logs | resource | KMS key for access-logs bucket. |
| aws_kms_alias.alb_logs | resource | KMS alias for ALB logs key. |
| aws_cloudwatch_metric_alarm.alb_5xx | resource | ALB 5xx alarm. |
| aws_cloudwatch_metric_alarm.target_5xx | resource | Target 5xx alarm. |
| data.aws_route53_zone.alias | data source | Route53 zone lookup. |
| aws_route53_record.alias | resource | Route53 A alias records. |

---

## Notes

- The `:443` listener returns a default **403 Access denied** response. Downstream stacks must add listener rules for routing.
- ALB access logs use **SSE-S3 (AES256)** because KMS is not supported for ALB delivery buckets.
- Setting `nat_gateway_eips` adds allow rules for those EIPs on ports 80 and 443.
- `lb_sg` exists in the schema but is unused; the module creates and manages its own security group.
- CloudWatch alarms use the ALB `arn_suffix` dimension and publish to `alarm_sns_topic_arn`.

---

## Related Projects

- `modules/network` supplies the VPC, public subnets, and NAT gateway EIPs.
- `modules/ecs-service` consumes `listener_443_arn`, `alb_sg_id`, and ALB DNS outputs.
- `modules/tg-fargate` creates target groups and listener rules.
- `modules/sns` provides the SNS topic for alarm notifications.

