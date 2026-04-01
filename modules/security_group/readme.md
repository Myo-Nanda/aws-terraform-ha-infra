# Security Group Module

Create a Security Group with Inbound and Outbound Rules.

## Usage

```hcl
module "ALB_SG" {
  source = "./modules/security_group"

  vpc_id         = module.VPC.vpc_id
  sg_name        = "ALB"
  sg_description = "Security Group for Load Balancer"
  tag_value      = "Development"

  sg_rule = {
    "http" = {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      type        = "ingress"
    }
    "all" = {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
      type        = "egress"
    }
  }
}
```

## Inputs

| Name | Description | Type | Default |
| :--------: | :----------------: | :----: | :-----------: |
| vpc_id | ID of the VPC where the Security Group will be created. | string | n/a |
| tag_value | Value for Name tag to identify the Security Group. | string | "Dev" |
| sg_name | Name of the Security Group. | string | "Dev Security Group" |
| sg_description | Description of the Security Group. | string | "allow inbound HTTP, SSH and allow outbound all " |
| sg_rule | Map of rules to be added to the Security Group. Each rule should have a unique key and the value should be an object with the following attributes: port, protocol, cidr_blocks (optional), source_security_group_id (optional), and type (ingress or egress). | map(object({ port = number, protocol = string, cidr_blocks = optional(list(string)), source_security_group_id = optional(string), type = string })) | (see variables.tf    ) |

## Outputs

| Name | Description |
| :--------: | :----------------: |
| security_group_id | ID of the Security Group to use at resources that need to be associated with the Security Group such as Load Balancers and EC2 Instances. |
