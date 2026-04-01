# VPC Module

Create a VPC with Public and Private Subnets, an Internet Gateway, a NAT Gateway, an Elastic IP for NAT, Route Table for Public and Private Subnets.

## Usage

```hcl
module "Development_VPC" {
    source          = "./module/vpc"

    cidr_block      = "10.0.0.0/16"
    sub_number      = 2
    tag_value       = "Development"
    cidr_newbits    = 8
}
```

## Inputs

| Name | Description | Type | Default |
| :--------: | :----------------: | :----: | :-----------: |
| cidr_block | IPv4 range for VPC | string | "10.0.0.0/16" |
| sub_number | Number of Subnets to create in each Availability Zone | number | 2 |
| tag_value | Value for Name tag to identify the VPC and its resources | string | "Development" |
| cidr_newbits | Number of new bits to add to VPC CIDR block for subnetting. For example, if VPC CIDR is 10.0.0.0/16 and cidr_newbits is 8, the resulting subnet CIDR will be 10.0.0.0/24 | number | 8 |

## Outputs

| Name | Description |
| :--------: | :----------------: |
| vpc_id | ID for VPC to use at resources that need to be in the VPC such as Security Groups, Gateways and Endpoints. |
| public_subnet_ids | List of Subnet IDs that have internet access. |
| private_subnet_ids | List of Subnet IDs that are used for internal communication and Internet through NAT Gateway. |
| igw_id | Internet Gatway IDs for public subnet to have internet access. |
| vpc_cidr_block | IPv4 address range of the VPC. |
