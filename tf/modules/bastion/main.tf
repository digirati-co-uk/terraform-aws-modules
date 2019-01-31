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

data "aws_iam_policy_document" "assume_role_policy_ec2" {
  statement = {
    actions = [
      "sts:AssumeRole",
    ]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "bastion" {
  name               = "${var.prefix}-bastion"
  assume_role_policy = "${data.aws_iam_policy_document.assume_role_policy_ec2.json}"
}

data "aws_iam_policy_document" "bastion_abilities" {
  statement = {
    actions = [
      "route53:GetHostedZone",
      "route53:ListResourceRecordSets",
      "route53:ChangeResourceRecordSets",
      "route53:ChangeTagsForResource",
    ]

    resources = ["*"]
  }
}

resource "aws_iam_policy" "bastion_abilities" {
  name        = "${var.prefix}-bastion-abilities"
  description = "Bastion userdata abilities (route53)"
  policy      = "${data.aws_iam_policy_document.bastion_abilities.json}"
}

resource "aws_iam_role_policy_attachment" "bastion_abilities" {
  role       = "${aws_iam_role.bastion.name}"
  policy_arn = "${aws_iam_policy.bastion_abilities.arn}"
}

resource "aws_iam_instance_profile" "bastion" {
  name = "${var.prefix}-bastion"
  role = "${aws_iam_role.bastion.name}"
}

resource "aws_launch_configuration" "bastion" {
  name_prefix          = "${var.prefix}-bastion-"
  image_id             = "${var.ami}"
  instance_type        = "${var.instance_type}"
  iam_instance_profile = "${aws_iam_instance_profile.bastion.name}"
  key_name             = "${var.key_name}"

  security_groups = [
    "${aws_security_group.bastion.id}",
  ]

  user_data = <<EOF
#!/bin/bash

yum update -q -y

# install jq
yum install -q -y jq
yum remove ecs-init

# Route53 update
LOCALIP=$(curl -s "http://169.254.169.254/latest/meta-data/local-ipv4")
DOMAIN="bastion.${var.domain}"
HOSTEDZONEID="${var.zone_id}"
cat > /tmp/route53-record.txt <<EOFCAT
{
  "Comment": "A new record set for the zone.",
  "Changes": [
    {
      "Action": "UPSERT",
      "ResourceRecordSet": {
        "Name": "$DOMAIN",
        "Type": "A",
        "TTL": 60,
        "ResourceRecords": [
          {
            "Value": "$LOCALIP"
          }
        ]
      }
    }
  ]
}
EOFCAT
aws route53 change-resource-record-sets --hosted-zone-id $HOSTEDZONEID --change-batch file:///tmp/route53-record.txt

EOF
}

resource "aws_autoscaling_group" "bastion" {
  name                 = "${var.prefix}-bastion"
  launch_configuration = "${aws_launch_configuration.bastion.name}"

  max_size            = "1"
  min_size            = "1"
  vpc_zone_identifier = ["${var.subnets}"]

  default_cooldown = 0

  lifecycle {
    create_before_destroy = true
  }

  tag {
    key                 = "Name"
    value               = "${var.prefix}-bastion"
    propagate_at_launch = true
  }

  tag {
    key                 = "Project"
    value               = "${var.project}"
    propagate_at_launch = true
  }
}
