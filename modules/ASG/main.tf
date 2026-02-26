resource "aws_launch_template" "ASG_Launch_Template" {
  name          = var.launch_template_name
  image_id      = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name

  vpc_security_group_ids = [var.vpc_security_id]

  user_data = filebase64(var.custome_script)

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "${var.tag_value} ASG Instance"
    }
  }

}

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
  #   target_group_arns         = [var.target_group_arn]

}