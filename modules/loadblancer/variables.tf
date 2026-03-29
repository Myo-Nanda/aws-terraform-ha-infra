variable "lb_name" {
  description = "Name of Load Balancer"
  type        = string
  default     = "Development-LB"
}

variable "lb_type" {
  description = "Type of Load Balancer"
  type        = string
  default     = "application"
}

variable "vpc_security_group_id" {
  description = "Security Group ID to attach in Instance"
}

variable "subnet_id" {
  description = "Subnets ID to launch the instances in"
}

variable "tag_value" {
  description = "Tag Name"
  type        = string
  default     = "Dev"
}

variable "tg_name" {
  description = "target group attributes"
  type        = string
  default     = "dev-vms"
}

variable "vpc_id" {
  description = "ID of VPC to associate security group"
}

variable "port" {
  description = "port number to for listener"
  type        = number
  default     = 80
}

variable "protocol" {
  description = "protocol for listener"
  type        = string
  default     = "HTTP"
}

variable "listener_type" {
  description = "Listener Type"
  type        = string
  default     = "forward"
}