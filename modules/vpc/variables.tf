variable "cidr_block" {
  description = "IPv4 range for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "tag_value" {
  description = "Tag name for resources"
  type        = string
  default     = "Development"
}

variable "sub_number" {
  description = "Number of subnet to create for public and private each"
  type        = number
  default     = 1
}