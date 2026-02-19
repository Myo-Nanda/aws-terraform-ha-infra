variable "sg_name" {
  description = "Security Group Name"
  type = string
  default = "Dev Security Group"
}

variable "sg_description" {
  description = "Details of the Security Group"
  type = string
  default = "allow inbound HTTP, SSH and allow outbound all "
}

variable "vpc_id" {
  description = "ID of VPC to associate security group"
}

variable "tag_value" {
  description = "Tag Name"
  type = string
  default = "Dev"
}

variable "sg_rule" {
  type = map(object({
    port = number
    protocol = string
    cidr_blocks = optional(list(string))
    source_security_group_id = optional(string)
    type = string
  }))
  default = {
    "ssh" = {
      port = 22
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      type = "ingress"
    }
    "http" = {
      port = 80
      protocol = "tcp"
      source_security_group_id = "sg-06c6ac90b43d0db1f"
      type = "ingress"
    }
    "all_out" = {
        port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
        type = "egress"
    }
  }
}

