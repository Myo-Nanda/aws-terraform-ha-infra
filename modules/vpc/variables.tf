variable "cidr_block" {
  description = "IPv4 address range for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "tag_value" {
  description = "Value for Name tag to identify the VPC and its resources."
  type        = string
  default     = "Development"
}

variable "sub_number" {
  description = "Number of subnets to create for public and private to distribute across available Availability Zones"
  type        = number
  default     = 1
}

variable "cidr_newbits" {
  description = "Number of new bits to add to VPC CIDR block for subnetting. For example, if VPC CIDR is 10.0.0.0/16 and cidr_newbits is 8, the resulting subnet CIDR will be 10.0.0.0/24"
  type        = number
  default     = 8
}