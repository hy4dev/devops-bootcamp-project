###########################################################
# VPC
###########################################################
resource "aws_vpc" "devops_vpc" {
  cidr_block = "10.0.0.0/24"
  tags       = { Name = "devops-vpc" }
}

###########################################################
# Internet Gateway
###########################################################
resource "aws_internet_gateway" "devops_igw" {
  vpc_id = aws_vpc.devops_vpc.id
  tags   = { Name = "devops-igw" }
}

###########################################################
# Public Subnet
###########################################################
resource "aws_subnet" "devops_public_subnet" {
  vpc_id                  = aws_vpc.devops_vpc.id
  cidr_block              = "10.0.0.0/25"
  availability_zone       = var.az
  map_public_ip_on_launch = false
  tags                    = { Name = "devops-public-subnet" }
}

###########################################################
# Public Route Table
###########################################################
resource "aws_route_table" "devops_public_route_table" {
  vpc_id = aws_vpc.devops_vpc.id
  tags   = { Name = "devops-public-route-table" }
}

resource "aws_route" "devops_public_route" {
  route_table_id         = aws_route_table.devops_public_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.devops_igw.id
}

resource "aws_route_table_association" "devops_public_link" {
  subnet_id      = aws_subnet.devops_public_subnet.id
  route_table_id = aws_route_table.devops_public_route_table.id
}

###########################################################
# Elastic IP for NAT Gateway
###########################################################
resource "aws_eip" "devops_nat_eip" {
  domain = "vpc"
  tags   = { Name = "devops-nat-eip" }
}

###########################################################
# NAT Gateway
###########################################################
resource "aws_nat_gateway" "devops_ngw" {
  allocation_id = aws_eip.devops_nat_eip.id
  subnet_id     = aws_subnet.devops_public_subnet.id
  depends_on    = [aws_internet_gateway.devops_igw]
  tags          = { Name = "devops-ngw" }
}

###########################################################
# Private Subnet
###########################################################
resource "aws_subnet" "devops_private_subnet" {
  vpc_id            = aws_vpc.devops_vpc.id
  cidr_block        = "10.0.0.128/25"
  availability_zone = var.az
  tags              = { Name = "devops-private-subnet" }
}

###########################################################
# Private Route Table
###########################################################
resource "aws_route_table" "devops_private_route_table" {
  vpc_id = aws_vpc.devops_vpc.id
  tags   = { Name = "devops-private-route-table" }
}

resource "aws_route" "devops_private_route" {
  route_table_id         = aws_route_table.devops_private_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.devops_ngw.id
}

resource "aws_route_table_association" "devops_private_link" {
  subnet_id      = aws_subnet.devops_private_subnet.id
  route_table_id = aws_route_table.devops_private_route_table.id
}