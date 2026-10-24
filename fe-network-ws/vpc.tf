# Create VPC
resource "aws_vpc" "hc-frontend-vpc" {
  cidr_block           = var.vpc-cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "hc-frontend-vpc"
  }
}

# Create Internet Gateway
resource "aws_internet_gateway" "fe-igw" {
  vpc_id = aws_vpc.hc-frontend-vpc.id

  tags = {
    Name = "fe-igw"
  }
}

# Create NAT Gateway
resource "aws_eip" "fe-nat-eip" {
  domain = "vpc"

  tags = {
    Name = "fe-nat-eip"
  }
}
resource "aws_nat_gateway" "fe-nat" {
  allocation_id = aws_eip.fe-nat-eip.id
  subnet_id     = aws_subnet.public-subnet1.id

  tags = {
    Name = "fe-nat"
  }

  depends_on = [aws_internet_gateway.fe-igw]
}
# public route table
resource "aws_route_table" "public-rtb" {
  vpc_id = aws_vpc.hc-frontend-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.fe-igw.id
  }

  tags = {
    Name = "public-rtb"
  }
}
resource "aws_route_table_association" "public-subnet1-association" {
  subnet_id      = aws_subnet.public-subnet1.id
  route_table_id = aws_route_table.public-rtb.id
}

# Create private route table 01
resource "aws_route_table" "private-rtb01" {
  vpc_id = aws_vpc.hc-frontend-vpc.id

  route {
    cidr_block = var.vpc-cidr
    gateway_id = "local"
  }
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.fe-nat.id
  }

  tags = {
    Name = "private-rtb01"
  }
}
resource "aws_route_table_association" "private-subnet1-association" {
  subnet_id      = aws_subnet.private-subnet1.id
  route_table_id = aws_route_table.private-rtb01.id
}

# Create private route table 02
resource "aws_route_table" "private-rtb02" {
  vpc_id = aws_vpc.hc-frontend-vpc.id

  route {
    cidr_block = var.vpc-cidr
    gateway_id = "local"
  }
  # TODO : peering connection
  #   route {
  #     cidr_block = "0.0.0.0/0"
  #     nat_gateway_id = aws_nat_gateway.fe-nat.id
  #   }

  tags = {
    Name = "private-rtb02"
  }
}
resource "aws_route_table_association" "private-subnet2-association" {
  subnet_id      = aws_subnet.private-subnet2.id
  route_table_id = aws_route_table.private-rtb02.id
}

# Create private route table 03
resource "aws_route_table" "private-rtb03" {
  vpc_id = aws_vpc.hc-frontend-vpc.id

  route {
    cidr_block = var.vpc-cidr
    gateway_id = "local"
  }
  # TODO : peering connection
  #   route {
  #     cidr_block = "0.0.0.0/0"
  #     nat_gateway_id = aws_nat_gateway.fe-nat.id
  #   }

  tags = {
    Name = "private-rtb03"
  }
}
resource "aws_route_table_association" "private-subnet3-association" {
  subnet_id      = aws_subnet.private-subnet3.id
  route_table_id = aws_route_table.private-rtb03.id
}

# Create private subnets
resource "aws_subnet" "public-subnet1" {
  vpc_id     = aws_vpc.hc-frontend-vpc.id
  cidr_block = var.public-subnet1-cidr
  map_public_ip_on_launch = true
 
  tags = {
    Name = "public-subnet1"
  }
}
resource "aws_subnet" "public-subnet2" {
  vpc_id     = aws_vpc.hc-frontend-vpc.id
  cidr_block = var.public-subnet2-cidr

  tags = {
    Name = "public-subnet2"
  }
}
resource "aws_subnet" "public-subnet3" {
  vpc_id     = aws_vpc.hc-frontend-vpc.id
  cidr_block = var.public-subnet3-cidr

  tags = {
    Name = "public-subnet3"
  }
}

# Create private subnet
resource "aws_subnet" "private-subnet1" {
  vpc_id            = aws_vpc.hc-frontend-vpc.id
  cidr_block        = var.private-subnet1-cidr
  availability_zone = var.availability-zone-a

  tags = {
    Name = "private-subnet1"
  }
}
resource "aws_subnet" "private-subnet2" {
  vpc_id            = aws_vpc.hc-frontend-vpc.id
  cidr_block        = var.private-subnet2-cidr
  availability_zone = var.availability-zone-a

  tags = {
    Name = "private-subnet2"
  }
}
resource "aws_subnet" "private-subnet3" {
  vpc_id            = aws_vpc.hc-frontend-vpc.id
  cidr_block        = var.private-subnet3-cidr
  availability_zone = var.availability-zone-a

  tags = {
    Name = "private-subnet3"
  }
}