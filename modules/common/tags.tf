variable "env" { 
  type = string 
}
variable "name_base" { 
  type = string
}

locals {
  name_prefix = "${var.env}-${var.name_base}"
  tags = {
    Environment = var.env
    Project     = var.name_base
    ManagedBy   = "terraform"
  }
}

output "name_prefix" { 
  value = local.name_prefix
}
output "tags" { 
  value = local.tags
}
