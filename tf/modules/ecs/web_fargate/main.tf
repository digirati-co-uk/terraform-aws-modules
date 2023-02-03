module "target" {
  source = "../../load-balancing/target"

  name                             = var.name
  vpc                              = var.vpc
  hostname                         = var.hostname
  domain                           = var.domain
  path_patterns                    = var.path_patterns
  zone_id                          = var.zone_id
  create_route53_entry             = var.create_route53_entry
  ip_whitelist                     = var.ip_whitelist
  load_balancer_arn                = var.load_balancer_arn
  listener_arn                     = var.listener_arn
  priority                         = var.priority
  health_check_matcher             = var.health_check_matcher
  health_check_path                = var.health_check_path
  health_check_timeout             = var.health_check_timeout
  health_check_healthy_threshold   = var.health_check_healthy_threshold
  health_check_unhealthy_threshold = var.health_check_unhealthy_threshold
  health_check_interval            = var.health_check_interval
  deregistration_delay             = var.deregistration_delay
  target_type                      = "ip"
}

resource "aws_ecs_service" "service" {
  name            = var.name
  cluster         = var.cluster_id
  task_definition = var.task_definition_arn
  desired_count   = var.desired_count

  health_check_grace_period_seconds = var.health_check_grace_period_seconds

  load_balancer {
    target_group_arn = module.target.target_group_arn
    container_name   = var.container_name
    container_port   = var.container_port
  }

  # Specifying both a launch type and capacity provider strategy is not supported
  launch_type = var.use_fargate_spot ? null : "FARGATE"

  scheduling_strategy = var.scheduling_strategy

  network_configuration {
    subnets          = var.subnets
    security_groups  = var.security_group_ids
    assign_public_ip = false
  }

  dynamic "capacity_provider_strategy" {
    for_each = var.use_fargate_spot ? [{}] : []

    content {
      capacity_provider = "FARGATE_SPOT"
      weight            = 1
    }
  }

  dynamic "ordered_placement_strategy" {
    for_each = var.ordered_placement_strategies
    iterator = strategy

    content {
      type  = strategy.value["type"]
      field = strategy.value["field"]
    }
  }

  dynamic "placement_constraints" {
    for_each = var.placement_constraints
    iterator = constraint

    content {
      type       = constraint.value["type"]
      expression = constraint.value["expression"]
    }
  }

  lifecycle {
    # managed by scaling policy
    ignore_changes = [
      desired_count
    ]
  }
}
