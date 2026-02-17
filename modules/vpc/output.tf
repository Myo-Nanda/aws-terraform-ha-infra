output "vpc_id" {
  description = "ID for VPC"
  value       = aws_vpc.Dev_VPC.id
}

output "public_subnet_id" {
  description = "IDs for Public Subnets"
  value       = aws_subnet.Public_Subnet[*].id
}

output "private_subnet_id" {
  description = "IDs for Private Subnets"
  value       = aws_subnet.Private_Subnet[*].id
}

output "igw_id" {
  description = "ID for internet gateway"
  value = aws_internet_gateway.Dev_IGW.id
}