output "vpn_connection_id" {
  value = aws_vpn_connection.main.id
}

output "customer_gateway_id" {
  value = aws_customer_gateway.main.id
}

output "vpn_tunnel1_address" {
  value = aws_vpn_connection.main.tunnel1_address
}

output "vpn_tunnel2_address" {
  value = aws_vpn_connection.main.tunnel2_address
}

output "vpn_configuration_xml" {
  value     = aws_vpn_connection.main.customer_gateway_configuration
  sensitive = true
}

output "vpn_outputs" {
  value = {
    vpn_connection_id   = aws_vpn_connection.main.id
    customer_gateway_id = aws_customer_gateway.main.id
    tunnel1_address     = aws_vpn_connection.main.tunnel1_address
    tunnel2_address     = aws_vpn_connection.main.tunnel2_address
  }
}
