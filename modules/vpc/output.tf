output "vpc_id" {
  description = "ID for VPC to use at resources that need to be in the VPC such as Security Groups, Gateways and Endpoints."
  value       = aws_vpc.VPC.id
}

output "public_subnet_ids" {
  description = "List of Subnet IDs that have internet access"
  value       = aws_subnet.Public_Subnet[*].id
}

output "private_subnet_ids" {
  description = "List of Subnet IDs that are used for internal communication and Internet through NAT Gateway"
  value       = aws_subnet.Private_Subnet[*].id
}

output "igw_id" {
  description = "Internet Gatway IDs for public subnet to have internet access"
  value       = aws_internet_gateway.IGW.id
}

output "vpc_cidr_block" {
  description = "IPv4 address range of the VPC"
  value       = aws_vpc.VPC.cidr_block
}