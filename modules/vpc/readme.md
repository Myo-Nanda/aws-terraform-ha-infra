# VPC Module

Create a VPC with Public and Private Subnets, an Internet Gateway, a NAT Gateway, an Elastic IP for NAT, Route Table for Public and Private Subnets.

## Usage

```hcl
moduule "Development_VPC" {
    source          = "./module/vpc"

    cidr_block  = "10.0.0.0/16"
    sub_number      = 2
    tag_value       = "Development"
}
```

## Inputs

| Name | Description | Type | Default |
| :--------: | :----------------: | :----: | :-----------: |
| cidr_block | IPv4 range for VPC | string | "10.0.0.0/16" |

## Outputs

| Name | Description |
| :--------: | :----------------: |
| vpc_id | IPv4 range for VPC |
