#Launch template for instance created by AutoScaling Group
resource "aws_launch_template" "ASG_Launch_Template" {
  name          = var.launch_template_name
  image_id      = var.ami_id
  instance_type = var.instance_type

  iam_instance_profile {
    name = var.iam_role
  }

  vpc_security_group_ids = [var.vpc_security_id]

  user_data = filebase64(var.custome_script)

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "${var.tag_value} ASG Instance"
    }
  }

}

#AutoScaling Group
resource "aws_autoscaling_group" "Auto_Scaling_Group" {
  name             = var.asg_name
  max_size         = var.max_size
  min_size         = var.min_size
  desired_capacity = var.desired_capacity

  launch_template {
    id      = aws_launch_template.ASG_Launch_Template.id
    version = var.ASG_version
  }

  vpc_zone_identifier = var.subnet_id
  target_group_arns   = [var.target_group_arn]

  # lifecycle block to ignore changes to desired_capacity, so that it doesn't get reset to the default value when the ASG scales up or down based on the CloudWatch alarms
  lifecycle {
    ignore_changes = [desired_capacity]
  }
}

# Attach AutoScaling Group to target group of Application Load Balancer
resource "aws_autoscaling_attachment" "example" {
  autoscaling_group_name = aws_autoscaling_group.Auto_Scaling_Group.name
  lb_target_group_arn    = var.target_group_arn
}

# AutoScaling Group Scale Up Policy, to increase instance capacity by a specific number when the cloudwatch alarm is triggered
resource "aws_autoscaling_policy" "Scale_Up_Policy" {
  name                   = "Scale_Up_Policy"
  autoscaling_group_name = aws_autoscaling_group.Auto_Scaling_Group.name
  scaling_adjustment     = var.scaling_adjustment
  adjustment_type        = var.adjustment_type
  cooldown               = var.cooldown_seconds
}

# AutoScaling Group Scale Down Policy, to decrease instance capacity by a specific number when the cloudwatch alarm is triggered
resource "aws_autoscaling_policy" "Scale_Down_Policy" {
  name                   = "Scale_Down_Policy"
  autoscaling_group_name = aws_autoscaling_group.Auto_Scaling_Group.name
  scaling_adjustment     = var.scaling_adjustment * -1
  adjustment_type        = var.adjustment_type
  cooldown               = var.cooldown_seconds

}

# CloudWatch Alarm to trigger Scale Up Policy when the average CPU utilization exceeds a certain threshold
resource "aws_cloudwatch_metric_alarm" "Scale_Up_Alarm" {
  alarm_name          = "Scale-Up-Alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = var.evaluation_periods
  metric_name         = var.metric_name
  namespace           = var.namespace
  period              = var.period
  statistic           = var.statistic
  threshold           = var.threshold
  alarm_description   = "Alarm when CPU exceeds threshold"
  alarm_actions       = [aws_autoscaling_policy.Scale_Up_Policy.arn]

  dimensions = {
    autoscaling_group_name = aws_autoscaling_group.Auto_Scaling_Group.name
  }
}

# CloudWatch Alarm to trigger Scale Down Policy when the average CPU utilization drops below a certain threshold
resource "aws_cloudwatch_metric_alarm" "Scale_Down_Alarm" {
  alarm_name          = "Scale-Down-Alarm"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = var.evaluation_periods
  metric_name         = var.metric_name
  namespace           = var.namespace
  period              = var.period
  statistic           = var.statistic
  threshold           = var.threshold * -1
  alarm_description   = "Alarm when CPU drops below threshold"
  alarm_actions       = [aws_autoscaling_policy.Scale_Down_Policy.arn]

  dimensions = {
    autoscaling_group_name = aws_autoscaling_group.Auto_Scaling_Group.name
  }
}