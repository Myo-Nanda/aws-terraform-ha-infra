variable "launch_template_name" {
  description = "Name of Launch Template"
  type        = string
  default     = "launch-template"
}

variable "ami_id" {
  description = "ID for AMI"
  type        = string
}

variable "instance_type" {
  description = "Type of EC2 instance (e.g., t3.small, t3.medium)."
  type        = string
  default     = "t3.small"
}

variable "iam_role" {
  description = "The name of the IAM role to be attached to the instances"
  type        = string
}

variable "vpc_security_id" {
  description = "VPC Security Group ID to associate with the instances"
  type        = string
}

variable "custome_script" {
  description = "Path to custom script file that will be executed on instance launch (user_data)"
  type        = string
}

variable "tag_value" {
  description = "The value to identify the ASG resources"
  type        = string
  default     = "Development"
}

variable "asg_name" {
  description = "Name of Auto Scaling Group"
  type        = string
  default     = "auto-scaling-group"
}

variable "max_size" {
  description = "Maximum number of instances the ASG can scale out to"
  type        = number
  default     = 4
}

variable "min_size" {
  description = "Minimum number of instances the ASG can scale in to"
  type        = number
  default     = 1
}

variable "desired_capacity" {
  description = "Number of instances that should be running in the Auto Scaling Group"
  type        = number
  default     = 2
}

variable "ASG_version" {
  description = "Launch Template version to use for Auto Scaling Group (e.g., $Latest, $Default, or specific version number)"
  type        = string
  default     = "$Latest"
}

variable "target_group_arn" {
  description = "Target Group ARN to attach Auto Scaling Group instances to"
  type        = string
}

variable "subnet_id" {
  description = "List of subnet IDs for Auto Scaling Group instances to launch in"
  type        = list(string)
}

variable "scaling_adjustment" {
  description = "Number of instances to add or remove when the cloudwatch alarm triggers"
  type        = number
  default     = 1

}

variable "adjustment_type" {
  description = "Type of scaling adjustment (e.g., ChangeInCapacity, ExactCapacity, PercentChangeInCapacity)"
  type        = string
  default     = "ChangeInCapacity"

}

variable "cooldown_seconds" {
  description = "Cooldown period in seconds after a scaling activity before another scaling activity can occur"
  type        = number
  default     = 300

}

variable "evaluation_periods" {
  description = "Number of periods over which data is compared to the specified threshold"
  type        = number
  default     = 2

}

variable "metric_name" {
  description = "Name of the CloudWatch metric to monitor (e.g., CPUUtilization, NetworkIn, MemoryUtilization)"
  type        = string
  default     = "CPUUtilization"
}

variable "namespace" {
  description = "Namespace of the CloudWatch metric (e.g., AWS/EC2, AWS/ApplicationELB)"
  type        = string
  default     = "AWS/EC2"
}

variable "period" {
  description = "The period, in seconds, over which the specified statistic is applied"
  type        = number
  default     = 300
}

variable "statistic" {
  description = "The statistic to apply to the alarm's associated metric (e.g., Average, Sum, Minimum, Maximum)"
  type        = string
  default     = "Average"
}

variable "threshold" {
  description = "The value against which the specified statistic is evaluated"
  type        = number
  default     = 85
}