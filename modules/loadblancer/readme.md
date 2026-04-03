# Load Balancer Module

This module creates an Application Load Balancer (ALB) with associated target group and listener to distribute incoming traffic across multiple EC2 instances. The ALB will provide high availability and scalability for your applications by automatically routing traffic to healthy instances based on specified rules.

## Usage

```hcl
module "ALB" {  
  source = "./modules/loadblancer"

  lb_name               = "WebApp-ALB"
  lb_type               = "application"
  vpc_id                = module.VPC.vpc_id
  subnet_id             = module.VPC.public_subnet_ids
  vpc_security_group_id = module.ALB_SG.SG_id
  tag_value             = "Production"
  tg_name               = "WebApp-Target-Group"
  target_group_port     = 80
  target_group_protocol = "HTTP"
  listener_port         = 80
  listener_protocol     = "HTTP"
  listener_type         = "forward"
}
```

## Inputs

| Name | Description | Type | Default | Required |
|:--------:|:--------:|:--------:|:--------:|:--------:|:--------:|
| lb_name | Name of the Load Balancer | string | "Development-LB" | no |
| lb_type | Type of Load Balancer (application or network) | string | "application" | no |
| vpc_security_group_ids | Security Group IDs to associate with Load Balancer | list(string) | - | yes |
| subnet_id | Subnet IDs to associate with Load Balancer | list(string) | - | yes |
| tag_value | Tag value to identify the Load Balancer and Target Group | string | "Development" | no |
| target_group_name | Name of the Target Group | string | "dev-vms" | no |
| vpc_id | VPC ID where Load Balancer and Target Group will be created | string | - | yes |
| target_group_port | Port on which Target Group will listen and forward traffic to instances | number | 80 | no |
| target_group_protocol | Protocol for Target Group | string | "HTTP" | no |
| listener_port | Port on which Load Balancer will listen and forward traffic to instances | number | 80 | no |
| listener_protocol | Protocol for Load Balancer | string | "HTTP" | no |
| listener_type | Type of action for listener to forward traffic to target group | string | "forward" | no |

## Outputs

| Name | Description |
| :--------: | :--------: |
| target_group_arn | ARN of the Target Group |
| alb_dns_name | DNS name of the Load Balancer to access the application |
