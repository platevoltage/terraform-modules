customer_ip_address    = "203.0.113.21"    # replace with real acme3 primary VPN IP
customer_cidr          = "100.67.0.0/17"
customer_ip_address_dr = "203.0.113.22"    # replace with real acme3 DR VPN IP
customer_cidr_dr       = "100.67.128.0/17"

bgp_asn            = 65003
static_routes_only = false

tunnel_ike_versions                 = ["ikev2"]
tunnel_phase1_integrity_algorithms  = ["SHA2-256", "SHA2-384", "SHA2-512"]
tunnel_phase1_encryption_algorithms = ["AES256", "AES256-GCM-16"]
tunnel_phase1_dh_group_numbers      = [14, 19, 20, 21]
tunnel_phase2_integrity_algorithms  = ["SHA2-256", "SHA2-384", "SHA2-512"]
tunnel_phase2_encryption_algorithms = ["AES256", "AES256-GCM-16"]
tunnel_phase2_dh_group_numbers      = [14, 19, 20, 21]
