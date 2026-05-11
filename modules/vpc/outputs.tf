output "vpc_id" {
  value = aws_vpc.main.id
}

output "vpc_cidr" {
  value = aws_vpc.main.cidr_block
}

output "private_subnet_ids" {
  value = aws_subnet.private[*].id
}

output "private_route_table_ids" {
  value = aws_route_table.private[*].id
}

output "public_subnet_ids" {
  value = aws_subnet.public[*].id
}

output "vpc_outputs" {
  value = {
    vpc_id                  = aws_vpc.main.id
    vpc_cidr                = aws_vpc.main.cidr_block
    private_subnet_ids      = aws_subnet.private[*].id
    private_route_table_ids = aws_route_table.private[*].id
    public_subnet_ids       = aws_subnet.public[*].id
  }
}
