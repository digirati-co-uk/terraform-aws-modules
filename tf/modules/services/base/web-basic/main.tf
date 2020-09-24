###############
# ECS SERVICE #
###############

resource "aws_ecs_service" "service" {
  name            = var.name
  cluster         = var.cluster_id
  task_definition = var.task_definition_arn
  desired_count   = var.desired_count
  iam_role        = aws_iam_role.service.id

  health_check_grace_period_seconds = var.health_check_grace_period_seconds

  load_balancer {
    target_group_arn = aws_alb_target_group.service.arn
    container_name   = var.container_name
    container_port   = var.container_port
  }

  scheduling_strategy = var.scheduling_strategy

  depends_on = [
    aws_iam_role_policy.service
  ]
}

####################
# ALB TARGET GROUP #
####################

resource "aws_alb_target_group" "service" {
  name                 = var.name
  port                 = 80
  protocol             = "HTTP"
  vpc_id               = var.vpc
  deregistration_delay = var.deregistration_delay

  health_check {
    path                = var.health_check_path
    timeout             = var.health_check_timeout
    healthy_threshold   = var.health_check_healthy_threshold
    unhealthy_threshold = var.health_check_unhealthy_threshold
    interval            = var.health_check_interval
    matcher             = var.health_check_matcher
  }
}

resource "aws_alb_listener_rule" "http" {
  count        = var.load_balancer_http_listener_arn == "" ? 0 : length(var.path_patterns)
  listener_arn = var.load_balancer_http_listener_arn
  priority     = var.service_number_http + count.index

  action {
    type             = "forward"
    target_group_arn = "${aws_alb_target_group.service.arn}"
  }

  condition {
    host-header {
      values = ["${var.hostname == "" ? "${var.domain}" : "${var.hostname}.${var.domain}"}"]
    }
  }

  condition {
    path-pattern {
      values = ["${element(var.path_patterns, count.index)}"]
    }
  }

  lifecycle {
    ignore_changes = ["priority"]
  }
}

resource "aws_alb_listener_rule" "https" {
  count        = var.load_balancer_https_listener_arn == "" ? 0 : length(var.path_patterns)
  listener_arn = var.load_balancer_https_listener_arn
  priority     = var.service_number_https + count.index

  action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.service.arn
  }

  condition {
    field  = "host-header"
    values = ["${var.hostname == "" ? "${var.domain}" : "${var.hostname}.${var.domain}"}"]
  }

  condition {
    field  = "path-pattern"
    values = ["${element(var.path_patterns, count.index)}"]
  }

  lifecycle {
    ignore_changes = ["priority"]
  }
}

#######
# DNS #
#######

resource "aws_route53_record" "service" {
  count   = var.hostname == "" ? 0 : 1
  zone_id = var.zone_id
  name    = "${var.hostname}.${var.domain}"
  type    = "A"

  alias {
    name                   = var.load_balancer_fqdn
    zone_id                = var.load_balancer_zone_id
    evaluate_target_health = false
  }
}
