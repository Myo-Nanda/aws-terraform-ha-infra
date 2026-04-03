variable "lb_name" {
  description = "Name of Load Balancer"
  type        = string
  default     = "Development-LB"
}

variable "lb_type" {
  description = "Load Balancer Type (application or network)"
  type        = string
  default     = "application"
}

variable "vpc_security_group_ids" {
  description = "Security Group IDs to associate with Load Balancer"
  type        = list(string)
}

variable "subnet_id" {
  description = "List of Subnet IDs to associate with Load Balancer"
  type        = list(string)
}

variable "tag_value" {
  description = "Tag value to identify the resources created by this module"
  type        = string
  default     = "Development"
}

variable "target_group_name" {
  description = "Name of Target Group"
  type        = string
  default     = "dev-vms"
}

variable "vpc_id" {
  description = "VPC ID where Load Balancer and Target Group will be created"
  type        = string
}

variable "target_group_port" {
  description = "Port on which Target Group will listen and forward traffic to instances"
  type        = number
  default     = 80
}

variable "target_group_protocol" {
  description = "Protocol for Target Group"
  type        = string
  default     = "HTTP"
}

variable "listener_port" {
  description = "Port on which Load Balancer will listen and forward traffic to instances"
  type        = number
  default     = 80
}

variable "listener_protocol" {
  description = "Protocol for Load Balancer"
  type        = string
  default     = "HTTP"
}

variable "listener_type" {
  description = "Type of action for listener to forward traffic to target group"
  type        = string
  default     = "forward"
}