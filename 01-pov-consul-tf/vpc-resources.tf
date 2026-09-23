#############################################################
# Create custom VPC
#############################################################
resource "aws_vpc" "dashboard-vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "dashboard-vpc"
  }
}

#############################################################
# Create Internet Gateway
#############################################################
resource "aws_internet_gateway" "dashboard-igw" {
  vpc_id = aws_vpc.dashboard-vpc.id

  tags = {
    Name = "dashboard-igw"
  }
}

#############################################################
# Create NAT Gateway
#############################################################
resource "aws_eip" "dashboard-nat-eip" {
  domain = "vpc"

  tags = {
    Name = "dashboard-nat-eip"
  }
}
resource "aws_nat_gateway" "dashboard-nat" {
  allocation_id = aws_eip.dashboard-nat-eip.id
  subnet_id     = aws_subnet.dashboard-public-subnet1.id

  tags = {
    Name = "dashboard-nat"
  }

  depends_on = [aws_internet_gateway.dashboard-igw]
}

#############################################################
# Create public subnet
#############################################################
resource "aws_subnet" "dashboard-public-subnet1" {
  vpc_id                  = aws_vpc.dashboard-vpc.id
  cidr_block              = "10.0.0.0/24"
  availability_zone       = "ap-northeast-1a"
  map_public_ip_on_launch = true    # Makes it a public subnet

  tags = {
    Name = "dashboard-public-subnet1"
  }
}
resource "aws_subnet" "dashboard-public-subnet2" {
  vpc_id                  = aws_vpc.dashboard-vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "ap-northeast-1c"
  map_public_ip_on_launch = true    # Makes it a public subnet
  tags = {
    Name = "dashboard-public-subnet2"
  }
}

#############################################################
# Create private subnet
#############################################################
resource "aws_subnet" "dashboard-private-subnet1" {
  vpc_id                  = aws_vpc.dashboard-vpc.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "ap-northeast-1a"

  tags = {
    Name = "dashboard-private-subnet1"
  }
}
resource "aws_subnet" "dashboard-private-subnet2" {
  vpc_id                  = aws_vpc.dashboard-vpc.id
  cidr_block              = "10.0.3.0/24"
  availability_zone       = "ap-northeast-1c"
  tags = {
    Name = "dashboard-private-subnet2"
  }
}

#############################################################
# Create route table and subnet association
#############################################################
resource "aws_default_route_table" "dashboard-public-rtb" {
  default_route_table_id = aws_vpc.dashboard-vpc.default_route_table_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.dashboard-igw.id
  }

  tags = {
    Name = "dashboard-public-rtb"
  }
}

resource "aws_route_table_association" "dashboard-public-subnet1-association" {
  subnet_id      = aws_subnet.dashboard-public-subnet1.id
  route_table_id = aws_default_route_table.dashboard-public-rtb.id
}

resource "aws_route_table_association" "dashboard-public-subnet2-association" {
  subnet_id      = aws_subnet.dashboard-public-subnet2.id
  route_table_id = aws_default_route_table.dashboard-public-rtb.id
}

# private route table
resource "aws_route_table" "dashboard-private-rtb" {
  vpc_id = aws_vpc.dashboard-vpc.id

  route {
    cidr_block = "10.0.0.0/16"
    gateway_id = "local"
  }
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.dashboard-nat.id
  }

  tags = {
    Name = "dashboard-private-rtb"
  }
}
resource "aws_route_table_association" "dashboard-private-subnet1-association" {
  subnet_id      = aws_subnet.dashboard-private-subnet1.id
  route_table_id = aws_route_table.dashboard-private-rtb.id
}
resource "aws_route_table_association" "dashboard-private-subnet2-association" {
  subnet_id      = aws_subnet.dashboard-private-subnet2.id
  route_table_id = aws_route_table.dashboard-private-rtb.id
}

#############################################################
# Create security group
#############################################################
resource "aws_security_group" "jump-host-sg" {
  name        = "jump-host-sg"
  description = "Security Group for Jump Host"
  vpc_id      = aws_vpc.dashboard-vpc.id

  tags = {
    Name = "jump-host-sg"
  }
}
resource "aws_security_group" "dashboard-alb-sg" {
  name        = "dashboard-alb-sg"
  description = "Security Group for Dashboard ALB"
  vpc_id      = aws_vpc.dashboard-vpc.id

  tags = {
    Name = "dashboard-alb-sg"
  }
}
resource "aws_security_group" "dashboard-instance-sg" {
  name        = "dashboard-instance-sg"
  description = "Security Group for Dashboard Instance"
  vpc_id      = aws_vpc.dashboard-vpc.id

  tags = {
    Name = "dashboard-instance-sg"
  }
}
resource "aws_security_group" "counting-alb-sg" {
  name        = "counting-alb-sg"
  description = "Security Group for Counting ALB"
  vpc_id      = aws_vpc.dashboard-vpc.id

  tags = {
    Name = "counting-alb-sg"
  }
}
resource "aws_security_group" "counting-instance-sg" {
  name        = "counting-instance-sg"
  description = "Security Group for Counting Instance"
  vpc_id      = aws_vpc.dashboard-vpc.id

  tags = {
    Name = "counting-instance-sg"
  }
}
#############################################################
# Security Group Rules (Ingress & Egress)
#############################################################

# ==========================================
# JUMP HOST SG RULES
# ==========================================
resource "aws_vpc_security_group_ingress_rule" "jump_host_inbound_ssh" {
  security_group_id = aws_security_group.jump-host-sg.id
  description       = "SSH from anywhere"
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  to_port           = 22
  ip_protocol       = "tcp"
}
resource "aws_vpc_security_group_egress_rule" "jump_host_outbound_dashboard" {
  security_group_id            = aws_security_group.jump-host-sg.id
  description                  = "SSH management to dashboard instances"
  referenced_security_group_id = aws_security_group.dashboard-instance-sg.id
  from_port                    = 8000
  to_port                      = 8000
  ip_protocol                  = "tcp"
}
resource "aws_vpc_security_group_egress_rule" "jump_host_outbound_counting" {
  security_group_id            = aws_security_group.jump-host-sg.id
  description                  = "SSH management to counting instances"
  referenced_security_group_id = aws_security_group.counting-instance-sg.id
  from_port                    = 9000
  to_port                      = 9000
  ip_protocol                  = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "jump_host_outbound_dashboard-ssh" {
  security_group_id            = aws_security_group.jump-host-sg.id
  description                  = "SSH management to dashboard instances"
  referenced_security_group_id = aws_security_group.dashboard-instance-sg.id
  from_port                    = 22
  to_port                      = 22
  ip_protocol                  = "tcp"
}
resource "aws_vpc_security_group_egress_rule" "jump_host_outbound_counting-ssh" {
  security_group_id            = aws_security_group.jump-host-sg.id
  description                  = "SSH management to counting instances"
  referenced_security_group_id = aws_security_group.counting-instance-sg.id
  from_port                    = 22
  to_port                      = 22
  ip_protocol                  = "tcp"
}

# ==========================================
# DASHBOARD ALB SG RULES
# ==========================================
resource "aws_vpc_security_group_ingress_rule" "dashboard-alb-inbound-all-http" {
  security_group_id = aws_security_group.dashboard-alb-sg.id
  description       = "HTTP from anywhere"
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  to_port           = 80
  ip_protocol       = "tcp"
}
resource "aws_vpc_security_group_egress_rule" "dashboard-alb_outbound_dashboard" {
  security_group_id            = aws_security_group.dashboard-alb-sg.id
  description                  = "Route to dashboard instances"
  referenced_security_group_id = aws_security_group.dashboard-instance-sg.id
  from_port                    = 8000
  to_port                      = 8000
  ip_protocol                  = "tcp"
}
# ==========================================
# DASHBOARD INSTANCE SG RULES
# ==========================================
resource "aws_vpc_security_group_ingress_rule" "dashboard-instance-inbound-tcp" {
  security_group_id = aws_security_group.dashboard-instance-sg.id
  description       = "Traffic from Dashboard ALB"
  referenced_security_group_id = aws_security_group.dashboard-alb-sg.id
  from_port         = 8000
  to_port           = 8000
  ip_protocol       = "tcp"
}
resource "aws_vpc_security_group_ingress_rule" "dashboard-instance-inbound-ssh" {
  security_group_id = aws_security_group.dashboard-instance-sg.id
  description       = "Traffic from Dashboard ALB"
  referenced_security_group_id = aws_security_group.jump-host-sg.id
  from_port         = 22
  to_port           = 22
  ip_protocol       = "tcp"
}
resource "aws_vpc_security_group_egress_rule" "dashboard-instance_outbound_counting-alb" {
  security_group_id            = aws_security_group.dashboard-instance-sg.id
  description                  = "Route to Dashboard ALB"
  referenced_security_group_id = aws_security_group.counting-alb-sg.id
  from_port                    = 80
  to_port                      = 80
  ip_protocol                  = "tcp"
}
resource "aws_vpc_security_group_egress_rule" "dashboard_instance_outbound_internet" {
  security_group_id = aws_security_group.dashboard-instance-sg.id
  description       = "Allow instances to reach internet via NAT GW"
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "tcp"
  from_port         = 443
  to_port           = 443
}
# ==========================================
# COUNTING ALB SG RULES
# ==========================================
resource "aws_vpc_security_group_ingress_rule" "counting-alb-inbound-dashboard-instance" {
  security_group_id = aws_security_group.counting-alb-sg.id
  description       = "Traffic from Dashboard Instances"
  referenced_security_group_id = aws_security_group.dashboard-instance-sg.id
  from_port         = 80
  to_port           = 80
  ip_protocol       = "tcp"
}
resource "aws_vpc_security_group_egress_rule" "counting-alb_outbound_counting-instance" {
  security_group_id            = aws_security_group.counting-alb-sg.id
  description                  = "Route to Counting Instances"
  referenced_security_group_id = aws_security_group.counting-instance-sg.id
  from_port                    = 9000
  to_port                      = 9000
  ip_protocol                  = "tcp"
}
# ==========================================
# COUNTING INSTANCE SG RULES
# ==========================================
resource "aws_vpc_security_group_ingress_rule" "counting-instance-inbound-counting-alb" {
  security_group_id = aws_security_group.counting-instance-sg.id
  description       = "Traffic from Counting ALB"
  referenced_security_group_id = aws_security_group.counting-alb-sg.id
  from_port         = 9000
  to_port           = 9000
  ip_protocol       = "tcp"
}
resource "aws_vpc_security_group_ingress_rule" "counting-instance-inbound-ssh" {
  security_group_id = aws_security_group.counting-instance-sg.id
  description       = "SSH administration from Jump Host"
  referenced_security_group_id = aws_security_group.jump-host-sg.id
  from_port         = 22
  to_port           = 22
  ip_protocol       = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "counting_instance_outbound_internet" {
  security_group_id = aws_security_group.counting-instance-sg.id
  description       = "Allow instances to reach internet via NAT GW"
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "tcp"
  from_port         = 443
  to_port           = 443
}