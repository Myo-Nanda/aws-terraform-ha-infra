output "instance_id" {
  description = "ID of the Instance"
  value       = { for k, v in aws_instance.Dev_Instance : k => v.id }
}