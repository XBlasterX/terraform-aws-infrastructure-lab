resource "aws_vpc" "lab" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "terraform-lab-vpc"
  }
}


resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.lab.id
  cidr_block              = var.public_subnet_cidr
  availability_zone       = "eu-north-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "terraform-public-subnet"
  }
}


resource "aws_internet_gateway" "lab" {
  vpc_id = aws_vpc.lab.id

  tags = {
    Name = "terraform-lab-igw"
  }
}


resource "aws_route_table" "public" {
  vpc_id = aws_vpc.lab.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.lab.id
  }

  tags = {
    Name = "terraform-public-rt"
  }
}


resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}