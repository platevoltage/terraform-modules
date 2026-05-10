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
    bgp_asn                = number
    customer_cidr          = string
    static_routes_only     = optional(bool, false)
    common_tags            = map(string)
  })
}
