output "log_group_name" {
  description = "Name of the CloudWatch log group that has been created"
  value       = "${aws_cloudwatch_log_group.log.name}"
}
