output "target_group_arn" {
  value = aws_lb_target_group.LB_Target_Group.arn
}

output "alb_dns_name" {
  value = aws_lb.Dev_LB.dns_name
}