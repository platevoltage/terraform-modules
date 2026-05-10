variable "aws_run_role_arn" {
  description = "IAM role ARN that TFC workspaces will assume via OIDC dynamic credentials"
  type        = string
  default     = ""
}

variable "org" {
  description = "Organization abbreviation passed to BaseConfig workspace"
  type        = string
  default     = "spr"
}

variable "project" {
  description = "Project name passed to BaseConfig workspace"
  type        = string
}

variable "env" {
  description = "Environment name passed to BaseConfig workspace"
  type        = string
  default     = "dev"
}

variable "aws_region" {
  description = "AWS region passed to BaseConfig workspace"
  type        = string
  default     = "us-east-1"
}
