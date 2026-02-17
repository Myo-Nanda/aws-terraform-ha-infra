data "aws_availability_zones" "az" {
    state = "available"
}

resource "aws_vpc" "Dev_VPC" {
  cidr_block = var.vpc_cidr_block
  instance_tenancy = "default"

  tags = {
    Name = "${var.tag_value} VPC"
  }
}

resource "aws_subnet" "Public_Subnet" {
  count = var.sub_number
  vpc_id = aws_vpc.Dev_VPC.id
  cidr_block = cidrsubnet(aws_vpc.Dev_VPC.cidr_block, 8, count.index)
  availability_zone = data.aws_availability_zones.az.names[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.tag_value} Public VPC"
  }
}

resource "aws_subnet" "Private_Subnet" {
  count = var.sub_number
  vpc_id = aws_vpc.Dev_VPC.id
  cidr_block = cidrsubnet(aws_vpc.Dev_VPC.cidr_block, 8, count.index +10)
  availability_zone = data.aws_availability_zones.az.names[count.index]

  tags = {
    Name = "${var.tag_value} Private VPC"
  }
}

resource "aws_internet_gateway" "Dev_IGW" {
  vpc_id = aws_vpc.Dev_VPC.id

  tags = {
    Name = "${var.tag_value} IGW"
  }
}

resource "aws_route_table" "Public_RT" {
    vpc_id = aws_vpc.Dev_VPC.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.Dev_IGW.id
    }

    tags = {
      Name = "${var.tag_value} Public RT"
    }
}

resource "aws_route_table_association" "Dev_Public_Sub_RT" {
    count = 2
    subnet_id = aws_subnet.Public_Subnet[count.index].id
    route_table_id = aws_route_table.Public_RT.id
}

resource "aws_route_table" "Private_RT" {
  vpc_id = aws_vpc.Dev_VPC.id

  tags = {
    Name = "${var.tag_value} Private RT"
  }
}

resource "aws_route_table_association" "Dev_Private_Sub_RT" {
    count = 2
  subnet_id = aws_subnet.Private_Subnet[count.index].id
  route_table_id = aws_route_table.Private_RT.id
}