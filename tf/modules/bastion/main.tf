# Bastion module

resource "aws_security_group" "bastion" {
  name        = "${var.prefix}-bastion"
  description = "SSH access"
  vpc_id      = "${var.vpc}"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.ip_whitelist}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    "Project" = "${var.project}"
  }
}

resource "aws_instance" "bastion" {
  instance_type          = "${var.instance_type}"
  ami                    = "${var.ami}"
  key_name               = "${var.key_name}"
  vpc_security_group_ids = ["${aws_security_group.bastion.id}"]
  subnet_id              = "${var.subnet}"

  user_data = <<EOF
#!/bin/bash

yum update -q -y

# install jq
yum install -q -y jq
yum remove ecs-init

EOF

  tags {
    "Name"    = "${var.prefix}-bastion"
    "Project" = "${var.project}"
  }
}

resource "aws_eip" "bastion" {
  instance = "${aws_instance.bastion.id}"
  vpc      = true
}

resource "aws_route53_record" "bastion" {
  zone_id = "${var.dns_zone}"
  name    = "bastion.${var.domain}"
  type    = "A"
  ttl     = "60"

  records = ["${aws_eip.bastion.public_ip}"]

  depends_on = [
    "aws_eip.bastion",
  ]
}
