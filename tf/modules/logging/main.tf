resource "aws_cloudwatch_log_group" "log" {
  name              = var.cloudwatch_log_group_name
  retention_in_days = var.cloudwatch_log_retention_days

  tags = {
    "Project" = var.project
  }
}
