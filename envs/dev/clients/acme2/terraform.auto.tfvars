# Customer IPs and CIDRs are managed as TFC workspace variables in hcp-admin.
# Update client_workspace_vars in hcp-admin/locals.tf when real values are received.

bgp_asn            = 65002
static_routes_only = false

tunnel_ike_versions                 = ["ikev2"]
tunnel_phase1_integrity_algorithms  = ["SHA2-256", "SHA2-384", "SHA2-512"]
tunnel_phase1_encryption_algorithms = ["AES256", "AES256-GCM-16"]
tunnel_phase1_dh_group_numbers      = [14, 19, 20, 21]
tunnel_phase2_integrity_algorithms  = ["SHA2-256", "SHA2-384", "SHA2-512"]
tunnel_phase2_encryption_algorithms = ["AES256", "AES256-GCM-16"]
tunnel_phase2_dh_group_numbers      = [14, 19, 20, 21]
