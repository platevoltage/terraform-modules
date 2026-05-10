output "transit_gateway_id" {
  value = aws_ec2_transit_gateway.main.id
}

output "transit_gateway_arn" {
  value = aws_ec2_transit_gateway.main.arn
}

output "transit_gateway_route_table_id" {
  value = aws_ec2_transit_gateway.main.association_default_route_table_id
}

output "transit_gateway_outputs" {
  value = {
    transit_gateway_id             = aws_ec2_transit_gateway.main.id
    transit_gateway_arn            = aws_ec2_transit_gateway.main.arn
    transit_gateway_route_table_id = aws_ec2_transit_gateway.main.association_default_route_table_id
  }
}
