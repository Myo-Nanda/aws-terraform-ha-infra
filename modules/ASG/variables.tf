variable "key_path" {
  description = "File path to the ssh public key"
  type        = string
  default     = "/home/robin/.ssh/id_rsa.pub"
}

variable "launch_template_name" {
  description = "Name of Launch Template"
  type        = string
  default     = "dev-launch-template"
}

variable "ami_id" {
  description = "ID for AMI"
  type        = string
  default     = "ami-0ac0e4288aa341886"
}

variable "instance_type" {
  description = "Type of EC2 instance"
  type        = string
  default     = "t3.micro"
}

variable "key_name" {
  description = "SSH Key Pair Name"
  type        = string
}

variable "iam_role" {
  description = "IAM role for instance"
  type = string
  default = "EC2-SSM"
}

variable "vpc_security_id" {
  description = "VPC Security Group ID"
  type        = string
}

variable "custome_script" {
  description = "Path to custom script file"
  type        = string
}

variable "tag_value" {
  description = "Tag Name"
  type        = string
  default     = "Dev"
}

variable "asg_name" {
  description = "Name of Auto Scaling Group"
  type        = string
  default     = "dev-auto-scaling-group"
}

variable "max_size" {
  description = "Maximum size of Auto Scaling Group"
  type        = number
  default     = 3
}

variable "min_size" {
  description = "Minimum size of Auto Scaling Group"
  type        = number
  default     = 1
}

variable "desired_capacity" {
  description = "Desired capacity of Auto Scaling Group"
  type        = number
  default     = 2
}

variable "ASG_version" {
  description = "Launch Template version"
  type        = string
  default     = "$Latest"
}

variable "target_group_arn" {
  description = "ARN of Target Group"
  type        = string
}

variable "subnet_id" {
  description = "Subnets ID to lauch the instances"
  type        = list(string)
}

variable "scaling_adjustment" {
  description = "Number of instances to add or remove when the alarm triggers"
  type        = number
  default     = 1

}

variable "adjustment_type" {
  description = "Type of scaling adjustment (e.g., ChangeInCapacity, ExactCapacity, PercentChangeInCapacity)"
  type        = string
  default     = "ChangeInCapacity"

}

variable "cooldown_seconds" {
  description = "Cooldown period in seconds after a scaling activity"
  type        = number
  default     = 300

}

variable "evaluation_periods" {
  description = "Number of periods over which data is compared to the specified threshold"
  type        = number
  default     = 2

}

variable "metric_name" {
  description = "Name of the CloudWatch metric to monitor (e.g., CPUUtilization)"
  type        = string
  default     = "CPUUtilization"

}

variable "namespace" {
  description = "Namespace of the CloudWatch metric (e.g., AWS/EC2)"
  type        = string
  default     = "AWS/EC2"

}

variable "period" {
  description = "The period, in seconds, over which the specified statistic is applied"
  type        = number
  default     = 300

}

variable "statistic" {
  description = "The statistic to apply to the alarm's associated metric"
  type        = string
  default     = "Average"

}

variable "threshold" {
  description = "The value against which the specified statistic is compared"
  type        = number
  default     = 85

}