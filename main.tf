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

# module "Target_Instance" {
#   source = "./modules/instance"

#   subnet_id             = module.Dev_VPC.private_subnet_id
#   vpc_security_group_id = module.Instance_SG.SG_id
#   ami_id                = data.aws_ami.ami_id.id
#   custome_script        = "./custome_script.sh"
# }

module "Application_LoadBalaner" {
  source = "./modules/loadblancer"

  vpc_id                = module.Dev_VPC.vpc_id
  subnet_id             = module.Dev_VPC.public_subnet_id
  vpc_security_group_id = module.ALB_SG.SG_id
  tg_name = "dev-vms"
}

module "Auto_Scaling_Group" {
  source = "./modules/ASG"

  launch_template_name = "dev-launch-template"
  ami_id               = data.aws_ami.ami_id.id
  instance_type        = "t3.micro"
  key_name             = "DEV_key"
  key_path             = "/home/robin/.ssh/id_rsa.pub"
  vpc_security_id      = module.Instance_SG.SG_id
  custome_script       = "./custome_script.sh"
  tag_value            = "Dev"

  asg_name         = "dev-auto-scaling-group"
  max_size         = 4
  min_size         = 1
  desired_capacity = 2
  ASG_version      = "$Latest"
  subnet_id        = module.Dev_VPC.private_subnet_id
  target_group_arn = module.Application_LoadBalaner.target_group_arn
}

# output "instance_id" {
#   value = module.Target_Instance.instance_id
# }

# output "target_group_arn" {
#   value = module.Application_LoadBalaner.target_group_arn
# }

output "alb_dns_name" {
  value = module.Application_LoadBalaner.alb_dns_name
}
