resource "aws_lb" "Dev_LB" {
  name               = var.lb_name
  internal           = false
  load_balancer_type = var.lb_type
  security_groups    = [var.vpc_security_group_id]
  subnets            = var.subnet_id

  tags = {
    Name = "${var.tag_value} Load Balancer"
  }
}

resource "aws_lb_target_group" "LB_Target_Group" {
  name     = var.tg_name
  port     = var.port
  protocol = var.protocol
  vpc_id   = var.vpc_id
}

resource "aws_lb_target_group_attachment" "LB_Target_Group_Attachment" {
  for_each         = var.instance_id
  target_group_arn = aws_lb_target_group.LB_Target_Group.arn
  target_id        = each.value
  port             = var.port
}

resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.Dev_LB.arn
  port              = var.port
  protocol          = var.protocol

  default_action {
    type             = var.listener_type
    target_group_arn = aws_lb_target_group.LB_Target_Group.arn
  }
}