###########
# SERVICE #
###########

resource "aws_ecs_service" "service" {
  name            = "${var.name}"
  cluster         = "${var.cluster_id}"
  task_definition = "${var.task_definition_arn}"
  desired_count   = "${var.desired_count}"

  depends_on = [
    "aws_iam_role_policy.service",
  ]
}
