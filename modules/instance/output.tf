output "instance_id" {
  description = "ID of the Instance"
  value       = aws_instance.Dev_Instance[*].id
}