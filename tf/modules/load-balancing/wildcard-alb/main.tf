##################
# SECURITY GROUP #
##################

resource "aws_security_group" "web" {
  name        = "${var.prefix}-${var.name}"
  description = "Web access for ALB"
  vpc_id      = var.vpc

  # HTTP access from anywhere
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = var.ip_whitelist
  }

  # HTTPS access from anywhere
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = var.ip_whitelist
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

#######
# ALB #
#######

resource "aws_alb" "lb" {
  name = "${var.prefix}-${var.name}"

  subnets = var.subnets

  security_groups = flatten(
    [
      var.security_groups,
      aws_security_group.web.id
    ]
  )

  idle_timeout = var.idle_timeout_seconds

  tags = {
    Project = var.project
  }
}

resource "aws_alb_target_group" "default" {
  name                 = "${var.prefix}-${var.name}-default"
  port                 = 80
  protocol             = "HTTP"
  vpc_id               = var.vpc
  deregistration_delay = 30

  health_check {
    path                = "/"
    timeout             = 30
    healthy_threshold   = 2
    unhealthy_threshold = 2
    interval            = 60
    matcher             = "200,404"
  }
}

resource "aws_alb_listener" "http" {
  count = var.redirect_http_to_https ? 0 : 1

  load_balancer_arn = aws_alb.lb.id
  port              = 80
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_alb_target_group.default.id
    type             = "forward"
  }
}

resource "aws_alb_listener" "http_redirect" {
  count = var.redirect_http_to_https ? 1 : 0

  load_balancer_arn = aws_alb.lb.id
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_302"
    }
  }
}

resource "aws_alb_listener" "https" {
  load_balancer_arn = aws_alb.lb.id
  port              = 443
  protocol          = "HTTPS"

  ssl_policy      = var.elb_ssl_policy
  certificate_arn = var.certificate_arn

  default_action {
    target_group_arn = aws_alb_target_group.default.id
    type             = "forward"
  }
}
