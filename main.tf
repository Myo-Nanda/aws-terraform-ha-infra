terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
  required_version = ">= 1.12"
}

provider "aws" {
  region  = "ap-southeast-1"
  profile = "Mgod"
}

module "Dev_VPC" {
  source = "./modules/vpc"

  sub_number = 2
}

module "ALB_SG" {
  source = "./modules/security_group"

  vpc_id         = module.Dev_VPC.vpc_id
  sg_name        = "ALB"
  sg_description = "Security Group for Load Balancer"

  sg_rule = {
    "http" = {
      port        = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      type        = "ingress"
    }
    "all" = {
      port        = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
      type        = "egress"
    }
  }
}

module "Instance_SG" {
  depends_on = [module.ALB_SG]
  source     = "./modules/security_group"

  vpc_id         = module.Dev_VPC.vpc_id
  sg_name        = "Instance"
  sg_description = "Security Group for Instances"

  sg_rule = {
    "http" = {
      port                     = 80
      protocol                 = "tcp"
      source_security_group_id = module.ALB_SG.SG_id
      type                     = "ingress"
    }
    "all" = {
      port        = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
      type        = "egress"
    }
  }
}

data "aws_ami" "ami_id" {
  most_recent = true

  filter {
    name   = "name"
    values = ["al2023-ami-2023*-kernel-6.1-x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["137112412989"]
}

module "Target_Instance" {
  source = "./modules/instance"

  subnet_id             = module.Dev_VPC.private_subnet_id
  vpc_security_group_id = module.Instance_SG.SG_id
  ami_id = data.aws_ami.ami_id.id
}