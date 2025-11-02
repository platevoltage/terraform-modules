variable "app_name" {
  type        = string
  description = "Application name"
}

variable "port" {
  type = number
}

variable "priority" {
  type = number
}

variable "image_repo" {
  description = "Name of the ECR image repository"
  type        = string
}

variable "image_tag" {
  description = "Tag of the ECR image to deploy"
  type        = string
}

variable "git_repo" {
  description = "GitHub repo full path, e.g., org/repo"
  type        = string
}

variable "git_branch" {
  description = "Branch name to trigger the pipeline"
  type        = string
  default     = "main"
}

variable "healthcheck_interval" {
  type    = number
  default = 10
}

variable "healthcheck_timeout" {
  type    = number
  default = 5
}

variable "healthcheck_retries" {
  type    = number
  default = 5
}

variable "healthcheck_start_period" {
  type    = number
  default = 30
}

variable "healthcheck_endpoint" {
  type    = string
  default = "/health"
}

variable "codebuild_compute_type" {
  description = "Compute type for CodeBuild (e.g. BUILD_GENERAL1_MEDIUM)"
  type        = string
}

variable "codebuild_image" {
  description = "CodeBuild image to use (e.g. aws/codebuild/amazonlinux-aarch64-standard:3.0)"
  type        = string
}

variable "fargate_cpu" {
  description = "The amount of CPU (in CPU units) to allocate for the Fargate task. Valid values are 256, 512, 1024, 2048, or 4096."
  type        = number
}

variable "fargate_memory" {
  description = "The amount of memory (in MiB) to allocate for the Fargate task. Must be compatible with the selected CPU value."
  type        = number
}

variable "include_secret" {
  description = ""
  type        = bool
}

variable "aurora_username_arn" {
  description = "ARN of the Secrets Manager secret key containing the Aurora PostgreSQL username"
  type        = string
}

variable "aurora_username_name" {
  description = "Name of the Secrets Manager key used for the Aurora PostgreSQL username"
  type        = string
}

variable "aurora_password_arn" {
  description = "ARN of the Secrets Manager secret key containing the Aurora PostgreSQL password"
  type        = string
}

variable "aurora_password_name" {
  description = "Name of the Secrets Manager key used for the Aurora PostgreSQL password"
  type        = string
}


