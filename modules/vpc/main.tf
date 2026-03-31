#AZs of the Region
data "aws_availability_zones" "az" {
  state = "available"
}

#VPC in given IP Range
resource "aws_vpc" "VPC" {
  cidr_block       = var.cidr_block
  instance_tenancy = "default"

  tags = {
    Name = "${var.tag_value} VPC"
  }
}

#Number of Public Subnet create upon given count
resource "aws_subnet" "Public_Subnet" {
  count                   = var.sub_number
  vpc_id                  = aws_vpc.VPC.id
  cidr_block              = cidrsubnet(aws_vpc.VPC.cidr_block, 8, count.index) # Add 8 bit to VPC CIDR
  availability_zone       = data.aws_availability_zones.az.names[count.index]
  map_public_ip_on_launch = true # Receive Public IPv4 address in EC2 instance

  tags = {
    Name = "${var.tag_value} Public VPC"
  }
}

# Number of Private Subnet create upon given count
resource "aws_subnet" "Private_Subnet" {
  count             = var.sub_number
  vpc_id            = aws_vpc.VPC.id
  cidr_block        = cidrsubnet(aws_vpc.VPC.cidr_block, 8, count.index + 10) # # Add 8 bit to VPC CIDR
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
  allocation_id = aws_eip.Elastic_IP
  subnet_id     = aws_subnet.Public_Subnet[0].id

  tags = {
    Name = "${var.tag_value} NAT GW"
  }

  depends_on = [aws_internet_gateway.IGW]
}

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

resource "aws_route_table_association" "Public_Sub_RT" {
  count          = var.sub_number
  subnet_id      = aws_subnet.Public_Subnet[count.index].id
  route_table_id = aws_route_table.Public_RT.id
}

resource "aws_route_table_association" "Private_Sub_RT" {
  count          = var.sub_number
  subnet_id      = aws_subnet.Private_Subnet[count.index].id
  route_table_id = aws_route_table.Private_RT.id
}