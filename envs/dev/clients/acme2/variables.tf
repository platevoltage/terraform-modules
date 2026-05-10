variable "customer_ip_address" {
  description = "Public IP of the customer's on-premises VPN device"
  type        = string
}

variable "bgp_asn" {
  description = "BGP ASN of the customer gateway (use 65000 if not running BGP)"
  type        = number
  default     = 65002
}

variable "customer_cidr" {
  description = "CIDR block of the customer on-premises network (RFC 6598 range)"
  type        = string
  default     = "100.66.0.0/16"
}

variable "static_routes_only" {
  description = "Use static routing instead of BGP"
  type        = bool
  default     = false
}
