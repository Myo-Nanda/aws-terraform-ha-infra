# Load Balancer Module

Create an Application Load Balancer with Listeners and Target Groups.

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
| lb_name | Name of the Load Balancer | string | "ALB" | no |
| lb_type | Type of Load Balancer (application or network) | string | "application" | no |
| vpc_id | VPC ID where Load Balancer will be created | string | - | yes |
| subnet_id | Subnet IDs where Load Balancer will be created | list(string) | - | yes |
| vpc_security_group_id | Security Group IDs to associate with Load Balancer | list(string) | - | yes |
| tg_name | Name of the Target Group | string | "ALB_Target_Group" | no |
| target_group_port | Port on which Target Group will listen and forward traffic to instances | number | 80 | no |
| target_group_protocol | Protocol for Target Group | string | "HTTP" | no |
| listener_port | Port on which Load Balancer will listen and forward traffic to instances | number | 80 | no |
| listener_protocol | Protocol for Load Balancer | string | "HTTP" | no |
| listener_type | Type of action for listener to forward traffic to target group | string | "forward" | no |

## Outputs

| Name | Description |
|:--------:|:--------:|
| target_group_arn | ARN of the Target Group |
| alb_dns_name | DNS name of the Load Balancer to access the application |
