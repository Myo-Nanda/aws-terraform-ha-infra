output "target_group_arn" {
  description = "ARN of Target Group"
  value = aws_lb_target_group.target_group.arn
}

output "alb_dns_name" {
  description = "DNS name of the Load Balancer to access the application"
  value = aws_lb.load_balancer.dns_name
}