###########
# SERVICE #
###########

resource "aws_ecs_service" "service" {
  name            = var.name
  cluster         = var.cluster_id
  task_definition = var.task_definition_arn
  desired_count   = var.desired_count

  health_check_grace_period_seconds = var.health_check_grace_period_seconds

  load_balancer {
    target_group_arn = aws_alb_target_group.service.arn
    container_name   = var.container_name
    container_port   = var.container_port
  }

  launch_type = var.launch_type

  scheduling_strategy = var.scheduling_strategy

  network_configuration {
    subnets          = var.subnets
    security_groups  = var.security_group_ids
    assign_public_ip = false
  }
}

##################
# SECURITY GROUP #
##################

resource "aws_security_group" "web" {
  count       = var.load_balancer_arn == "" ? 1 : 0
  name        = "${var.name}-web"
  description = "Web access for ${var.name}"
  vpc_id      = var.vpc

  ingress {
    from_port = 80
    to_port   = 80
    protocol  = "tcp"
    cidr_blocks = [
      flatten(var.ip_whitelist)
    ]
  }

  ingress {
    from_port = 443
    to_port   = 443
    protocol  = "tcp"
    cidr_blocks = [
      flatten(var.ip_whitelist)
    ]
  }

  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Project = var.project
  }
}

#############################
# APPLICATION LOAD BALANCER #
#############################

resource "aws_alb" "service" {
  count = var.load_balancer_arn == "" ? 1 : 0
  name  = var.name
  subnets = [
    flatten(var.subnets)
  ]

  security_groups = concat(
    [join("", aws_security_group.web.*.id)],
    var.security_group_ids,
  )

  tags = {
    Project = var.project
  }
}

resource "aws_alb_target_group" "service" {
  name                 = var.name
  port                 = 80
  protocol             = "HTTP"
  vpc_id               = var.vpc
  deregistration_delay = var.deregistration_delay
  target_type          = var.target_type

  health_check {
    path                = var.health_check_path
    timeout             = var.health_check_timeout
    healthy_threshold   = var.health_check_healthy_threshold
    unhealthy_threshold = var.health_check_unhealthy_threshold
    interval            = var.health_check_interval
    matcher             = var.health_check_matcher
  }
}

resource "aws_alb_listener" "http" {
  count             = var.load_balancer_arn == "" ? 1 : 0
  load_balancer_arn = join("", aws_alb.service.*.id)
  port              = 80
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_alb_target_group.service.id
    type             = "forward"
  }
}

resource "aws_alb_listener_rule" "http" {
  count        = var.load_balancer_https_listener_arn == "" ? 0 : length(var.path_patterns)
  listener_arn = var.load_balancer_https_listener_arn
  priority     = var.service_number_https + count.index

  action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.service.arn
  }

  condition {
    host_header {
      values = [var.hostname == "" ? var.domain : "${var.hostname}.${var.domain}"]
    }
  }

  condition {
    path_pattern {
      values = [element(var.path_patterns, count.index)]
    }
  }

  lifecycle {
    ignore_changes = [
      priority
    ]
  }
}

#######
# DNS #
#######

resource "aws_route53_record" "service" {
  count   = var.create_route53_entry ? 1 : 0
  zone_id = var.zone_id
  name    = var.hostname == "" ? var.domain : "${var.hostname}.${var.domain}"
  type    = "A"

  alias {
    name                   = var.load_balancer_fqdn
    zone_id                = var.load_balancer_zone_id
    evaluate_target_health = false
  }
}
