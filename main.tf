#Terraform and AWS provider configuration
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.38.0"
    }
  }
  required_version = ">= 1.12"
}

provider "aws" {
  region = "ap-southeast-1" #default region
}

#Create VPC, Subnets and other related resources
module "VPC" {
  source = "./modules/vpc"

  sub_number = 2
}

#Security Group for Application Load Balancer
module "ALB_SG" {
  source = "./modules/security_group"

  vpc_id         = module.VPC.vpc_id
  sg_name        = "ALB"
  sg_description = "Security Group for Load Balancer"

  #Allow http traffic from internet
  #Allow all outgoing traffic
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

#Security group for EC2 instances which launch by AutoScaling Group
module "Instance_SG" {
  source = "./modules/security_group"

  vpc_id         = module.VPC.vpc_id
  sg_name        = "Instance"
  sg_description = "Security Group for Instances"

  #Only allow http traffic  from ALB security group and
  #All outgoin traffic for updates/external calls
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

#Data source to find the AMI ID for instnaces
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

#Application Load Balancer, along with listener and target group
module "Application_LoadBalancer" {
  source = "./modules/loadblancer"

  vpc_id                = module.VPC.vpc_id
  subnet_id             = module.VPC.public_subnet_ids
  vpc_security_group_id = module.ALB_SG.SG_id
  tg_name               = "dev-vms"
}

#AutoScaling Group with scale up and scale down rule using cloud watch alarms, along with launch template for instances
module "AutoScaling_Group" {
  source = "./modules/ASG"

  launch_template_name = "dev-launch-template"
  ami_id               = data.aws_ami.ami_id.id
  instance_type        = "t3.small"
  vpc_security_id      = module.Instance_SG.SG_id
  custome_script       = "./custome_script.sh" #user_data to install nginx
  tag_value            = "Dev"
  iam_role             = "EC2-SSM" #IAM role to connect instance via Session Manager

  asg_name         = "dev-auto-scaling-group"
  max_size         = 4
  min_size         = 1
  desired_capacity = 2
  ASG_version      = "$Latest"
  subnet_id        = module.VPC.private_subnet_ids
  target_group_arn = module.Application_LoadBalancer.target_group_arn
}

#ALB DNS name to access the web app
# output "alb_dns_name" {
#   value = module.Application_LoadBalaner.alb_dns_name
# }