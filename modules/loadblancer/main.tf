#Application Load Balaner
resource "aws_lb" "load_balancer" {
  name               = var.lb_name
  internal           = false
  load_balancer_type = var.lb_type
  security_groups    = var.vpc_security_group_ids
  subnets            = var.subnet_id

  tags = {
    Name = "${var.tag_value} Load Balancer"
  }
}

#Target Group
resource "aws_lb_target_group" "target_group" {
  name     = var.target_group_name
  port     = var.target_group_port
  protocol = var.target_group_protocol
  vpc_id   = var.vpc_id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

#listener, ALB to forward traffic to instances
resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.load_balancer.arn
  port              = var.listener_port
  protocol          = var.listener_protocol

  default_action {
    type             = var.listener_type
    target_group_arn = aws_lb_target_group.target_group.arn
  }
}