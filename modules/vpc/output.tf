output "vpc_id" {
  description = "ID for VPC"
  value       = aws_vpc.VPC.id
}

output "public_subnet_ids" {
  description = "IDs for Public Subnets"
  value       = aws_subnet.Public_Subnet[*].id
}

output "private_subnet_ids" {
  description = "IDs for Private Subnets"
  value       = aws_subnet.Private_Subnet[*].id
}

output "igw_id" {
  description = "ID for internet gateway"
  value       = aws_internet_gateway.IGW.id
}

output "vpc_cidr_block" {
  description = "CIDR Block of the VPC"
  value       = aws_vpc.VPC.cidr_block
}