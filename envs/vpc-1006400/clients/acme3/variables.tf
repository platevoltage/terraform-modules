variable "customer_ip_address" {
  description = "Public IP of the primary on-premises VPN device"
  type        = string
}

variable "customer_cidr" {
  description = "CIDR block of the primary on-premises network"
  type        = string
}

variable "customer_ip_address_dr" {
  description = "Public IP of the DR on-premises VPN device"
  type        = string
}

variable "customer_cidr_dr" {
  description = "CIDR block of the DR on-premises network"
  type        = string
}

variable "bgp_asn" {
  description = "BGP ASN of the customer gateway"
  type        = number
  default     = 65003
}

variable "static_routes_only" {
  description = "Use static routing instead of BGP"
  type        = bool
  default     = false
}

variable "tunnel_ike_versions" {
  description = "IKE versions for both VPN tunnels"
  type        = list(string)
  default     = ["ikev2"]
}

variable "tunnel_phase1_integrity_algorithms" {
  description = "Phase 1 integrity algorithms"
  type        = list(string)
  default     = ["SHA2-256", "SHA2-384", "SHA2-512"]
}

variable "tunnel_phase1_encryption_algorithms" {
  description = "Phase 1 encryption algorithms"
  type        = list(string)
  default     = ["AES256", "AES256-GCM-16"]
}

variable "tunnel_phase1_dh_group_numbers" {
  description = "Phase 1 Diffie-Hellman group numbers"
  type        = list(number)
  default     = [14, 19, 20, 21]
}

variable "tunnel_phase2_integrity_algorithms" {
  description = "Phase 2 integrity algorithms"
  type        = list(string)
  default     = ["SHA2-256", "SHA2-384", "SHA2-512"]
}

variable "tunnel_phase2_encryption_algorithms" {
  description = "Phase 2 encryption algorithms"
  type        = list(string)
  default     = ["AES256", "AES256-GCM-16"]
}

variable "tunnel_phase2_dh_group_numbers" {
  description = "Phase 2 Diffie-Hellman group numbers"
  type        = list(number)
  default     = [14, 19, 20, 21]
}
