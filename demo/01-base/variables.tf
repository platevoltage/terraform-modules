# variables.tf
variable "env" {
  type        = string
  description = "Deployment environment identifier (for example: dev, staging, prod). Used in name_prefix, tags, log prefixes, and DNS/SSM path construction."
  default     = "dev"
}

variable "org" {
  type        = string
  description = "Organization or tenant identifier used to build name_prefix and hierarchical paths (org/project/env) for SSM and routing."
  default     = "example"
}

variable "project" {
  type        = string
  description = "Project identifier used in name_prefix, tags, logs bucket naming, and routing/SSM path construction."
  default     = "demo"
}

variable "admin_email" {
  type        = string
  description = "Email address subscribed to the SNS alerts topic for CloudWatch alarms (ALB 5xx and target 5xx)."
  default     = "admin@example.com"
}

variable "aws_region" {
  type        = string
  description = "AWS region to deploy into. Used for provider configuration, regional service ARNs, and region-specific resources (for example, ELB log delivery account mapping)."
  default     = "us-east-1"
}

variable "cert_arn" {
  type        = string
  description = "ACM certificate ARN used by the ALB HTTPS listener as the primary TLS certificate (passed as main_cert_arn)."
  default     = ""
}

variable "additional_cert_arn" {
  type        = string
  description = "Additional ACM certificate ARN reserved for future use (not currently passed into the ALB module configuration)."
  default     = ""
}

variable "allowed_ips" {
  type        = list(string)
  description = "IPv4 addresses allowed to reach the public ALB. Values can be plain IPs (x.x.x.x) or CIDRs. Plain IPs are normalized to /32 for security group rules."
  default     = ["0.0.0.0/0"]
}

variable "app_names" {
  type        = list(string)
  description = "List of application subdomain prefixes used to generate fqdn_map, Route53 alias records, and per-app SSM/path prefixes. Use an empty string to represent the root domain."
  default     = ["", "app"]
}

variable "base_domain" {
  type        = string
  description = "Base DNS domain hosted in Route53. Used to generate per-app FQDNs (for example, app.base_domain and base_domain) and create ALB alias records."
  default     = "example.com"
}

variable "natgw_count" {
  type        = string
  description = "NAT Gateway strategy for the VPC. Supported values: \"none\" (0 NAT gateways), \"one\" (single NAT gateway), \"all\" (one NAT gateway per AZ). Affects NAT EIPs that are also allow-listed on the ALB security group."
  default     = "one"
}
