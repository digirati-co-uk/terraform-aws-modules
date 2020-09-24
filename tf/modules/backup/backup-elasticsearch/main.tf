module "backup_task" {
  source = "git::https://github.com/digirati-co-uk/terraform-aws-modules.git//tf/modules/services/tasks/base/"

  environment_variables = {
    "DEBUG"                    = "True"
    "ES_HOST"                  = var.elasticsearch_url
    "REPOSITORY_NAME"          = var.repository_name
    "REMOVE_OLDER_THAN_DAYS"   = var.remove_older_than_days
    "SLACK_WEBHOOK_URL"        = var.slack_webhook_url
    "ENABLE_SLACK"             = "True"
    "REPOSITORY_SETTINGS"      = "{\"type\": \"s3\", \"settings\": {\"bucket\": \"${var.s3_bucket_name}\", \"base_path\": \"${var.s3_key_prefix}\", \"storage_class\": \"standard_ia\"}}"
    "REQUEST_TIMEOUT_SECONDS"  = var.request_timeout_seconds
    "SNAPSHOT_TIMEOUT_SECONDS" = var.snapshot_timeout_seconds
  }

  environment_variables_length = 9

  prefix           = var.prefix
  log_group_name   = var.log_group_name
  log_group_region = var.region
  log_prefix       = "${var.prefix}-backup-${var.backup_identifier}"

  family = "${var.prefix}-backup-${var.backup_identifier}"

  container_name = "${var.prefix}-backup-${var.backup_identifier}"

  cpu_reservation    = 0
  memory_reservation = 128

  docker_image = var.shutterbug_docker_image
}

resource "aws_ecs_task_definition" "backup_task" {
  family                = "${var.prefix}-backup-${var.backup_identifier}"
  container_definitions = module.backup_task.task_definition_json
  task_role_arn         = module.backup_task.role_arn
}

module "backup" {
  source = "git::https://github.com/digirati-co-uk/terraform-aws-modules.git//tf/modules/services/tasks/scheduled/"

  family              = "${var.prefix}-backup-${var.backup_identifier}"
  task_role_name      = module.backup_task.role_name
  region              = var.region
  account_id          = var.account_id
  cluster_arn         = var.cluster_id
  schedule_expression = var.cron_expression
  desired_count       = 1
  task_definition_arn = aws_ecs_task_definition.backup_task.arn
}
