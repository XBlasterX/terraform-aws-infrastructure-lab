terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }

  backend "s3" {
    bucket       = "terraform-state-377238675044-eu-north-1"
    key          = "terraform-aws-lab/terraform.tfstate"
    region       = "eu-north-1"
    encrypt      = true
    use_lockfile = true
  }
}

provider "aws" {
  region = var.aws_region
}
