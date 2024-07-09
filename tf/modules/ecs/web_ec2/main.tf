module "target" {
  source = "../../load-balancing/target"

  name                              = var.name
  vpc                               = var.vpc
  hostname                          = var.hostname
  domain                            = var.domain
  path_patterns                     = var.path_patterns
  zone_id                           = var.zone_id
  create_route53_entry              = var.create_route53_entry
  ip_whitelist                      = var.ip_whitelist
  load_balancer_arn                 = var.load_balancer_arn
  listener_arn                      = var.listener_arn
  priority                          = var.priority
  health_check_matcher              = var.health_check_matcher
  health_check_path                 = var.health_check_path
  health_check_timeout              = var.health_check_timeout
  health_check_healthy_threshold    = var.health_check_healthy_threshold
  health_check_unhealthy_threshold  = var.health_check_unhealthy_threshold
  health_check_interval             = var.health_check_interval
  deregistration_delay              = var.deregistration_delay
  target_type                       = "instance"
  stickiness_enabled                = var.load_balancer_stickiness_enabled
  stickiness_type                   = var.stickiness_type
  stickiness_cookie_duration        = var.stickiness_cookie_duration
  stickiness_cookie_name            = var.stickiness_cookie_name
  load_balancing_algorithm          = var.load_balancing_algorithm
  load_balancing_anomaly_mitigation = var.load_balancing_anomaly_mitigation
}

# Service
resource "aws_ecs_service" "service" {
  name            = var.name
  cluster         = var.cluster_id
  task_definition = var.task_definition_arn
  desired_count   = var.desired_count
  iam_role        = aws_iam_role.service.id

  health_check_grace_period_seconds = var.health_check_grace_period_seconds

  deployment_maximum_percent         = var.deployment_max_percent
  deployment_minimum_healthy_percent = var.deployment_min_healthy_percent

  load_balancer {
    target_group_arn = module.target.target_group_arn
    container_name   = var.container_name
    container_port   = var.container_port
  }

  # Specifying both a launch type and capacity provider strategy is not supported
  launch_type = length(var.capacity_provider_strategies) > 0 ? null : "EC2"

  scheduling_strategy = var.scheduling_strategy

  dynamic "capacity_provider_strategy" {
    for_each = var.capacity_provider_strategies
    iterator = strategy

    content {
      capacity_provider = strategy.value["capacity_provider"]
      weight            = strategy.value["weight"]
      base              = try(strategy.value["base"], null)
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

  depends_on = [
    aws_iam_role_policy.service
  ]
}

# IAM
data "aws_iam_policy_document" "assume_ecs_role" {
  statement {
    actions = [
      "sts:AssumeRole",
    ]

    principals {
      type        = "Service"
      identifiers = ["ecs.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "service" {
  name               = "${var.name}-service-role"
  assume_role_policy = data.aws_iam_policy_document.assume_ecs_role.json
}

data "aws_iam_policy_document" "service_abilities" {
  statement {
    actions = [
      "ec2:Describe*",
      "ec2:AuthorizeSecurityGroupIngress",
      "elasticloadbalancing:DeregisterInstancesFromLoadBalancer",
      "elasticloadbalancing:DeregisterTargets",
      "elasticloadbalancing:Describe*",
      "elasticloadbalancing:RegisterInstancesWithLoadBalancer",
      "elasticloadbalancing:RegisterTargets"
    ]

    resources = [
      "*",
    ]
  }
}
resource "aws_iam_role_policy" "service" {
  name   = "${var.name}-service-role-policy"
  role   = aws_iam_role.service.name
  policy = data.aws_iam_policy_document.service_abilities.json
}