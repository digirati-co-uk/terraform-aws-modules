data "aws_lb" "lb" {
  arn  = var.load_balancer_arn
}

##################
# SECURITY GROUP #
##################

resource "aws_security_group" "web" {
   name        = "${var.name}-web"
  description = "Web access for ${var.name}"
  vpc_id      = var.vpc

  ingress {
    from_port = 80
    to_port   = 80
    protocol  = "tcp"
    cidr_blocks = var.ip_whitelist
  }

  ingress {
    from_port = 443
    to_port   = 443
    protocol  = "tcp"
    cidr_blocks = var.ip_whitelist
  }

  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

#############################
# APPLICATION LOAD BALANCER #
#############################

resource "aws_alb_target_group" "service" {
  name                 = var.name
  port                 = 80
  protocol             = "HTTP"
  vpc_id               = var.vpc
  deregistration_delay = var.deregistration_delay
  target_type          = var.target_type

  stickiness {
    enabled            = var.stickiness_enabled
    type               = "app_cookie"
    cookie_name        = var.stickiness_cookie_name
  }

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
  listener_arn = var.listener_arn
  priority     = var.priority

  action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.service.arn
  }

  condition {
    host_header {
      values = [local.final_hostname]
    }
  }

  condition {
    path_pattern {
      values = var.path_patterns
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
  name    = local.final_hostname
  type    = "A"

  alias {
    name                   = data.aws_lb.lb.dns_name
    zone_id                = data.aws_lb.lb.zone_id
    evaluate_target_health = false
  }
}

locals {
  final_hostname = var.hostname == "" ? var.domain : "${var.hostname}.${var.domain}"
}