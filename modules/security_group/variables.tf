variable "sg_name" {
  description = "Name of the Security Group"
  type        = string
  default     = "Dev Security Group"
}

variable "sg_description" {
  description = "Description of the Security Group"
  type        = string
  default     = "allow inbound HTTP, SSH and allow outbound all "
}

variable "vpc_id" {
  description = "ID of the VPC where the Security Group will be created"
  type        = string
}

variable "tag_value" {
  description = "Value for the Name tag of the Security Group"
  type        = string
  default     = "Dev"
}

variable "sg_rule" {
  description = "Map of rules to be added to the Security Group. Each rule should have a unique key and the value should be an object with the following attributes: port, protocol, cidr_blocks (optional), source_security_group_id (optional), and type (ingress or egress)."
  type = map(object({
    from_port                = number
    to_port                  = number
    protocol                 = string
    cidr_blocks              = optional(list(string))
    source_security_group_id = optional(string)
    type                     = string
  }))
  default = {
    "ssh" = {
      from_port        = 22
      to_port          = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      type        = "ingress"
    }
    "http" = {
      from_port                = 80
      to_port                  = 80
      protocol                 = "tcp"
      source_security_group_id = "sg-06c6ac90b43d0db1f"
      type                     = "ingress"
    }
    "all_out" = {
      from_port        = 0
      to_port          = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
      type        = "egress"
    }
  }
}