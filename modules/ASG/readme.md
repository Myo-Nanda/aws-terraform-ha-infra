# AutoScaling Group (ASG) Module

This module creates an AutoScaling Group (ASG) with associated launch configuration, scaling policies, and CloudWatch alarms to manage the scaling of EC2 instances based on specified metrics. The ASG will automatically adjust the number of instances in response to changes in demand, ensuring high availability and performance for your applications.

## Usage

```hcl
module "asg" {
  source = "./modules/ASG"

  launch_template_name = "dev-launch-template"
  ami_id               = "ami-0ac0e4288aa341886" # May differ based on region
  instance_type        = "t3.small"
  vpc_security_id      = module.Instance_SG.SG_id
  custome_script       = "./custome_script.sh"
  tag_value            = "Development"
  iam_role             = "EC2-SSM"

  asg_name         = "dev-auto-scaling-group"
  max_size         = 4
  min_size         = 1
  desired_capacity = 2
  ASG_version      = "$Latest"
  subnet_id        = module.VPC.private_subnet_ids
  target_group_arn = module.Application_LoadBalancer.target_group_arn

  scaling_adjustment = 1
  adjustment_type    = "ChangeInCapacity"
  cooldown_seconds   = 300

  evaluation_periods = 1
  metric_name       = "CPUUtilization"
  namespace         = "AWS/EC2"
  period            = 300
  statistic         = "Average"
  threshold         = 70
}
```

## Inputs

| Name | Description | Type | Default | Required |
| :---: | :---: | :---: | :---: | :---: |
| launch_template_name | Name of the launch template | string | "launch-template" | no |
| ami_id | The ID of the Amazon Machine Image (AMI) to use for the instances in the ASG. | string | - | yes |
| instance_type | The type of instance (e.g., t3.small, t3.medium). | string | "t3.small" | no |
| iam_role | The name of the IAM role to be attached to the instances | string | - | yes |
| vpc_security_id | The ID of the security group to associate with the instances | string | - | yes |
| custome_script | Path to custom script file that will be executed on instance launch (user_data) | string | - | yes |
| tag_value | The value to identify the ASG resources | string | "Development" | no |
| asg_name | Name of the AutoScaling Group | string | "auto-scaling-group" | no |
| max_size | Maximum number of instances that the ASG can scale out to | integer | 4 | no |
| min_size | Minimum number of instances that the ASG can scale in to | integer | 1 | no |
| desired_capacity | Number of instances that should be running in the ASG | integer | 2 | no |
| ASG_version | Launch Template version to use for Auto Scaling Group (e.g., $Latest, $Default, or specific version number) | string | "$Latest" | no |
| target_group_arn | Target Group ARN to attach Auto Scaling Group instances to | string | - | yes |
| subnet_id | List of subnet IDs for Auto Scaling Group instances to launch in | list(string) | - | yes |
| scaling_adjustment | Number of instances to add or remove when the cloudwatch alarm triggers | integer | 1 | no |
| adjustment_type | Type of scaling adjustment (e.g., ChangeInCapacity, ExactCapacity, PercentChangeInCapacity). | string | "ChangeInCapacity" | no |
| cooldown_seconds | Cooldown period in seconds after a scaling activity before another scaling activity can occur | integer | 300 | no |
| evaluation_periods | Number of periods over which data is compared to the specified threshold. | integer | 2 | no |
| metric_name | The name of the CloudWatch metric to monitor (e.g., CPUUtilization, NetworkIn, MemoryUtilization). | string | "CPUUtilization" | no |
| namespace | The namespace of the CloudWatch metric (e.g., AWS/EC2, AWS/ApplicationELB). | string | "AWS/EC2" | no |
| period | The period in seconds over which the specified statistic is applied. | integer | 300 | no |
| statistic | The statistic to apply to the alarm's associated metric (e.g., Average, Sum, Minimum, Maximum). | string | "Average" | no |
| threshold | The value against which the specified statistic is compared when the alarm is evaluated. | number | 85 | no |

## Outputs

N/A
