variable "task_role_name" {
  description = "The name of the ECS task role to attach the CloudWatch exporter policy to"
  type        = string
}

variable "region" {
  description = "AWS region"
  type        = string
}

variable "account_id" {
  description = "AWS account ID"
  type        = string
}