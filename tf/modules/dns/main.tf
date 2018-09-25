# DNS

data "aws_route53_zone" "external" {
  name = "${var.domain}"
}

resource "aws_route53_zone" "internal" {
  name   = "${var.prefix}.${var.region}.internal"
  vpc_id = "${var.vpc}"

  tags {
    "Project" = "${var.project}"
  }
}
