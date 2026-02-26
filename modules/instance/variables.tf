variable "key_name" {
  description = "SSH Key name for Instance"
  type        = string
  default     = "DEV_key"
}

variable "key_path" {
  description = "File path to the ssh public key"
  type        = string
  default     = "/home/robin/.ssh/id_rsa.pub"
}

variable "instance_number" {
  description = "Number instance to launch"
  type        = number
  default     = 1
}

variable "ami_id" {
  description = "ID for AMI"
  type        = string
  default     = "ami-0ac0e4288aa341886"
}

variable "instance_type" {
  description = "Instance Type for the instance"
  type        = string
  default     = "t3.micro"
}

variable "subnet_id" {
  description = "Subnets ID to lauch the instances"
  type        = list(string)
}

variable "vpc_security_group_id" {
  description = "Security Group ID to attach in Instance"
  type        = string
}

variable "custome_script" {
  description = "user data for the instance"
}

variable "tag_value" {
  description = "Tag Name"
  type        = string
  default     = "Dev"
}