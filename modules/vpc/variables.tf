variable "vpc_cidr_block" {
  description = "IP block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "tag_value" {
  description = "Tag for resources"
  type        = string
  default     = "Development"
}

variable "sub_number" {
  description = "number of subnet"
  type        = number
  default     = 1
}