data "aws_iam_policy_document" "cloudwatch_event_assume_role" {
  statement {
    principals {
      type        = "Service"
      identifiers = ["events.amazonaws.com"]
    }

    actions = [
      "sts:AssumeRole",
    ]
  }
}

resource "aws_iam_role_policy_attachment" "task_execution_policy" {
  role       = var.task_role_name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role" "scheduled_task" {
  name               = "${var.family}-scheduled-task"
  assume_role_policy = data.aws_iam_policy_document.cloudwatch_event_assume_role.json
}

data "aws_iam_policy_document" "events_access_ecs" {
  statement {
    effect    = "Allow"
    actions   = ["ecs:RunTask"]
    resources = ["arn:aws:ecs:${var.region}:${var.account_id}:task-definition/${var.family}:*"]

    condition {
      test     = "StringLike"
      variable = "ecs:cluster"
      values   = [var.cluster_arn]
    }
  }
}

resource "aws_iam_role_policy" "events_access_ecs" {
  name   = "${var.family}-scheduled-task-events-ecs"
  role   = aws_iam_role.scheduled_task.id
  policy = data.aws_iam_policy_document.events_access_ecs.json
}

resource "aws_cloudwatch_event_rule" "event" {
  name                = var.family
  description         = "Runs task at a scheduled time"
  schedule_expression = var.schedule_expression
}

resource "aws_cloudwatch_event_target" "event_target" {
  target_id = var.family
  rule      = aws_cloudwatch_event_rule.event.name
  arn       = var.cluster_arn
  role_arn  = aws_iam_role.scheduled_task.arn

  ecs_target {
    task_count          = var.desired_count
    task_definition_arn = var.task_definition_arn
  }
}
