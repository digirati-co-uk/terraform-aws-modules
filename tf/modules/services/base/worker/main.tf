###########
# SERVICE #
###########

resource "aws_ecs_service" "service" {
  name                = var.name
  cluster             = var.cluster_id
  task_definition     = var.task_definition_arn
  desired_count       = var.desired_count
  scheduling_strategy = var.scheduling_strategy
}
