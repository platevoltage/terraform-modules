variable "org" {
  description = "Organization abbreviation used in resource naming"
  type        = string
  default     = "spr"
}

variable "project" {
  description = "Project name"
  type        = string
}

variable "env" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}
