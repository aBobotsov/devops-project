resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr_range
  enable_dns_hostnames = true
  tags                 = {
    name = "vpc"
  }
}

resource "aws_subnet" "primary" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = cidrsubnet(aws_vpc.vpc.cidr_block, 8, 1)
  map_public_ip_on_launch = true
  availability_zone       = var.az_main
}

resource "aws_subnet" "secondary" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = cidrsubnet(aws_vpc.vpc.cidr_block, 8, 2)
  map_public_ip_on_launch = true
  availability_zone       = var.az_secondary
}

resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.vpc.id
  tags   = {
    name = "internet-gateway"
  }
}

resource "aws_route_table" "route_table" {
  vpc_id = aws_vpc.vpc.id
  # route all traffic outside of vpc cidr to IGW
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway.id
  }
}

resource "aws_route_table_association" "primary_subnet_route" {
  subnet_id      = aws_subnet.primary.id
  route_table_id = aws_route_table.route_table.id
}

resource "aws_route_table_association" "secondary_subnet_route" {
  subnet_id      = aws_subnet.secondary.id
  route_table_id = aws_route_table.route_table.id
}

resource "aws_security_group" "security_group" {
  name   = "ecs-security-group"
  vpc_id = aws_vpc.vpc.id

  # TODO: fix this security horror
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    self        = "false"
    cidr_blocks = ["0.0.0.0/0"]
    description = "any"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
