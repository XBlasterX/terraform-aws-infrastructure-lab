variable "aws_region" {
  type        = string
  description = "AWS region"
}

variable "vpc_cidr" {
  type        = string
  description = "CIDR for VPC"
}

variable "public_subnet_cidr" {
  type        = string
  description = "CIDR for public subnet"
}

variable "instance_type" {
  type        = string
  description = "EC2 instance type"
}

variable "environment" {
  type        = string
  description = "Environment name"
}