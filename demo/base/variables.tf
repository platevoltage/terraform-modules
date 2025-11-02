# variables.tf
variable "account_id" {
  type        = string
  description = "AWS Account ID"
}

variable "env" {
  description = "Environment name"
}

variable "org" {
  description = "Org name"
}

variable "project" {
  description = "Project name"
}

variable "admin_email" {
  description = "For sending alarm notifications"
}

variable "aws_region" {
  description = "AWS Region"
}

variable "cert_arn" {
  type        = string
  description = "The ARN of the SSL certificate for HTTPS/ALB"
}

variable "additional_cert_arn" {
  type        = string
  description = "The ARN of the SSL certificate for HTTPS/ALB"
}

variable "allowed_ips" {
  description = "Your IP address for allow list"
  type        = list(string)
  default     = [""]
}

variable "app_names" {
  type    = list(string)
  default = [""]
}

variable "base_domain" {
  type = string
}

variable "natgw_count" {
  type = string
}
