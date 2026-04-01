#Availability Zones of the Region
data "aws_availability_zones" "az" {
  state = "available"
}

#VPC in given IPvv4 address Range
resource "aws_vpc" "VPC" {
  cidr_block       = var.cidr_block
  instance_tenancy = "default"

  tags = {
    Name = "${var.tag_value} VPC"
  }
}

#Number of Public Subnet created based on given count
resource "aws_subnet" "Public_Subnet" {
  count                   = var.sub_number
  vpc_id                  = aws_vpc.VPC.id
  cidr_block              = cidrsubnet(aws_vpc.VPC.cidr_block, var.cidr_newbits, count.index) # To avoid overlapping with private subnet CIDR, use count index as is for public subnet CIDR
  availability_zone       = data.aws_availability_zones.az.names[count.index]
  map_public_ip_on_launch = true # Automatically assign public IP to instances launched in public subnet

  tags = {
    Name = "${var.tag_value} Public VPC"
  }
}

# Number of Private Subnet created based on given count
resource "aws_subnet" "Private_Subnet" {
  count             = var.sub_number
  vpc_id            = aws_vpc.VPC.id
  cidr_block        = cidrsubnet(aws_vpc.VPC.cidr_block, var.cidr_newbits, count.index + var.sub_number) # To avoid overlapping with public subnet CIDR, add sub_number to count index
  availability_zone = data.aws_availability_zones.az.names[count.index]

  tags = {
    Name = "${var.tag_value} Private VPC"
  }
}

#Internet Gateway for Public Subnet to have internet
resource "aws_internet_gateway" "IGW" {
  vpc_id = aws_vpc.VPC.id

  tags = {
    Name = "${var.tag_value} IGW"
  }
}

#Elastic IP address
resource "aws_eip" "Elastic_IP" {
  domain = "vpc"

  tags = {
    Name = "${var.tag_value} EIP"
  }
}

#NAT Gateway for Private Subnet to have internet access
resource "aws_nat_gateway" "NAT_GW" {
  allocation_id = aws_eip.Elastic_IP.id
  subnet_id     = aws_subnet.Public_Subnet[0].id

  tags = {
    Name = "${var.tag_value} NAT GW"
  }

  depends_on = [aws_internet_gateway.IGW] # Ensure NAT Gateway is created after Internet Gateway to avoid dependency issues
}

#Route Table for Public Subnet to route internet traffic through Internet Gateway
resource "aws_route_table" "Public_RT" {
  vpc_id = aws_vpc.VPC.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.IGW.id
  }

  tags = {
    Name = "${var.tag_value} Public RT"
  }
}

#Route Table for Private Subnet to route internet traffic through NAT Gateway
resource "aws_route_table" "Private_RT" {
  vpc_id = aws_vpc.VPC.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.NAT_GW.id
  }

  tags = {
    Name = "${var.tag_value} Private RT"
  }
}

#Associate Public Subnets with Public Route Table
resource "aws_route_table_association" "Public_Sub_RT" {
  count          = var.sub_number
  subnet_id      = aws_subnet.Public_Subnet[count.index].id
  route_table_id = aws_route_table.Public_RT.id
}

#Associate Private Subnets with Private Route Table
resource "aws_route_table_association" "Private_Sub_RT" {
  count          = var.sub_number
  subnet_id      = aws_subnet.Private_Subnet[count.index].id
  route_table_id = aws_route_table.Private_RT.id
}