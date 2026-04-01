output "SG_id" {
  description = "ID of the Security Group to use at resources that need to be associated with the Security Group such as Load Balancers and EC2 Instances."
  value       = aws_security_group.Security_Group.id
}