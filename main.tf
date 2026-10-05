locals {
  project_name = "terraform-lab"

  common_tags = {
    Project     = local.project_name
    Environment = var.environment
    ManagedBy   = "lol"
  }
}

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023*-x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

module "network" {
  source = "./modules/network"

  vpc_cidr           = var.vpc_cidr
  public_subnet_cidr = var.public_subnet_cidr
  availability_zone  = "eu-north-1a"

  tags = local.common_tags
}

resource "aws_security_group" "web" {
  name        = "terraform-web-sg"
  description = "Allow HTTP traffic"
  vpc_id      = module.network.vpc_id

  tags = {
    Name = "terraform-web-sg"
  }
}


resource "aws_vpc_security_group_ingress_rule" "http" {
  security_group_id = aws_security_group.web.id

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 80
  to_port     = 80
  ip_protocol = "tcp"
}


resource "aws_vpc_security_group_egress_rule" "all" {
  security_group_id = aws_security_group.web.id

  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = "-1"
}


resource "aws_instance" "web" {
  ami           = data.aws_ami.amazon_linux.id
  instance_type = var.instance_type

  subnet_id = module.network.public_subnet_id

  vpc_security_group_ids = [
    aws_security_group.web.id
  ]

  user_data = <<-EOF
    #!/bin/bash
    dnf install -y httpd
    echo "<h1>Created by Terraform</h1>" > /var/www/html/index.html
    systemctl enable --now httpd
  EOF

  tags = merge(
    local.common_tags,
    {
      Name = "terraform-web"
    }
  )
}

moved {
  from = aws_vpc.lab
  to   = module.network.aws_vpc.lab
}

moved {
  from = aws_subnet.public
  to   = module.network.aws_subnet.public
}

moved {
  from = aws_internet_gateway.lab
  to   = module.network.aws_internet_gateway.lab
}

moved {
  from = aws_route_table.public
  to   = module.network.aws_route_table.public
}

moved {
  from = aws_route_table_association.public
  to   = module.network.aws_route_table_association.public
}