variable "site_2_site_vpn_config" {
  description = "Site-to-site VPN module configuration"
  type = object({
    account_id             = string
    env                    = string
    project                = string
    aws_region             = string
    name_prefix            = string
    client_name            = string
    transit_gateway_id     = string
    transit_gateway_rtb_id = string

    customer_ip_address    = string
    customer_cidr          = string
    customer_ip_address_dr = string
    customer_cidr_dr       = string

    bgp_asn            = number
    static_routes_only = optional(bool, false)

    tunnel_startup_action               = optional(string, "start")
    tunnel_dpd_timeout_action           = optional(string, "restart")
    tunnel_ike_versions                 = optional(list(string), ["ikev2"])
    tunnel_phase1_integrity_algorithms  = optional(list(string), ["SHA2-256", "SHA2-384", "SHA2-512"])
    tunnel_phase1_encryption_algorithms = optional(list(string), ["AES256", "AES256-GCM-16"])
    tunnel_phase1_dh_group_numbers      = optional(list(number), [14, 19, 20, 21])
    tunnel_phase2_integrity_algorithms  = optional(list(string), ["SHA2-256", "SHA2-384", "SHA2-512"])
    tunnel_phase2_encryption_algorithms = optional(list(string), ["AES256", "AES256-GCM-16"])
    tunnel_phase2_dh_group_numbers      = optional(list(number), [14, 19, 20, 21])

    common_tags = map(string)
  })
}
