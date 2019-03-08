data "aws_s3_bucket" "backup_bucket" {
  bucket = "${var.s3_bucket_name}"
}

module "backup_task" {
  source = "git::https://github.com/digirati-co-uk/terraform-aws-modules.git//tf/modules/services/tasks/base/"

  environment_variables = {
    "ENGINE_FAMILY"     = "${var.engine_family}"
    "ENGINE_VERSION"    = "${var.engine_version}"
    "DB_HOST"           = "${var.database_host}"
    "DB_PORT"           = "${var.database_port}"
    "DB_NAME"           = "${var.database_name}"
    "DB_USERNAME"       = "${var.database_username}"
    "DB_PASSWORD"       = "${var.database_password}"
    "SLACK_WEBHOOK_URL" = "${var.slack_webhook_url}"
    "S3_PREFIX"         = "s3://${data.aws_s3_bucket.backup_bucket.id}/${var.s3_key_prefix}"
  }

  environment_variables_length = 9

  prefix           = "${var.prefix}"
  log_group_name   = "${var.log_group_name}"
  log_group_region = "${var.region}"
  log_prefix       = "${var.prefix}-backup-${var.backup_identifier}"

  family = "${var.prefix}-backup-${var.backup_identifier}"

  container_name = "${var.prefix}-backup-${var.backup_identifier}"

  cpu_reservation    = 0
  memory_reservation = 128

  docker_image = "${var.backup_database_s3_docker_image}"

  mount_points = [
    {
      sourceVolume  = "${var.prefix}-backup-${var.backup_identifier}-docker"
      containerPath = "/var/run/docker.sock"
    },
  ]
}

resource "aws_ecs_task_definition" "backup_task" {
  family                = "${var.prefix}-backup-${var.backup_identifier}"
  container_definitions = "${module.backup_task.task_definition_json}"
  task_role_arn         = "${module.backup_task.role_arn}"

  volume {
    name      = "${var.prefix}-backup-${var.backup_identifier}-docker"
    host_path = "/var/run/docker.sock"
  }
}

data "aws_iam_policy_document" "backup_bucket_access" {
  statement {
    effect = "Allow"

    actions = [
      "s3:PutObject",
    ]

    resources = [
      "${data.aws_s3_bucket.backup_bucket.arn}/${var.s3_key_prefix}*",
      "${data.aws_s3_bucket.backup_bucket.arn}/${var.s3_key_prefix}/*",
    ]
  }
}

resource "aws_iam_role_policy" "backup_bucket_access" {
  name   = "${var.prefix}-backup-bucket-access"
  role   = "${module.backup_task.role_name}"
  policy = "${data.aws_iam_policy_document.backup_bucket_access.json}"
}

module "backup" {
  source = "git::https://github.com/digirati-co-uk/terraform-aws-modules.git//tf/modules/services/tasks/scheduled/"

  family              = "${var.prefix}-backup-${var.backup_identifier}"
  task_role_name      = "${module.backup_task.role_name}"
  region              = "${var.region}"
  account_id          = "${var.account_id}"
  cluster_arn         = "${var.cluster_id}"
  schedule_expression = "${var.cron_expression}"
  desired_count       = 1
  task_definition_arn = "${aws_ecs_task_definition.backup_task.arn}"
}
