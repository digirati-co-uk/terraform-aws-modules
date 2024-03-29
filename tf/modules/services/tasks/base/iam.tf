resource "aws_iam_role" "task" {
  name               = var.family
  assume_role_policy = data.aws_iam_policy_document.assume_ecs_role.json
}

data "aws_iam_policy_document" "assume_ecs_role" {
  statement {
    actions = [
      "sts:AssumeRole",
    ]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}
