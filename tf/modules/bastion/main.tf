data "aws_default_tags" "default_tags" {}

locals {
  asg_resources_to_tag = ["instance", "volume", "network-interface"]
}

resource "aws_security_group" "bastion" {
  name        = "${var.prefix}-bastion"
  description = "SSH access"
  vpc_id      = var.vpc

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = flatten(var.ip_whitelist)
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

data "aws_iam_policy_document" "assume_role_policy_ec2" {
  statement {
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
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy_ec2.json
}

data "aws_iam_policy_document" "bastion_abilities" {
  statement {
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
  policy      = data.aws_iam_policy_document.bastion_abilities.json
}

resource "aws_iam_role_policy_attachment" "bastion_abilities" {
  role       = aws_iam_role.bastion.name
  policy_arn = aws_iam_policy.bastion_abilities.arn
}

resource "aws_iam_instance_profile" "bastion" {
  name = "${var.prefix}-bastion"
  role = aws_iam_role.bastion.name
}

resource "aws_launch_template" "bastion" {
  name_prefix   = "${var.prefix}-bastion-"
  image_id      = var.ami == null ? data.aws_ami.amazon_linux_2023.id : var.ami
  instance_type = var.instance_type
  iam_instance_profile {
    name = aws_iam_instance_profile.bastion.name
  }

  network_interfaces {
    associate_public_ip_address = true
    security_groups = concat(
      [aws_security_group.bastion.id],
      var.additional_security_groups
    )
  }

  key_name = var.key_name

  dynamic "tag_specifications" {
    for_each = {
      for type in local.asg_resources_to_tag : type => data.aws_default_tags.default_tags
    }
    content {
      resource_type = tag_specifications.key
      tags          = tag_specifications.value.tags
    }
  }

  user_data = base64encode(<<EOF
#!/bin/bash

yum update -q -y

# install jq
yum install -q -y jq

# Route53 update
TOKEN=$(curl -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600")
LOCALIP=$(curl -s "http://169.254.169.254/latest/meta-data/public-ipv4" -H "X-aws-ec2-metadata-token: $TOKEN")
DOMAIN="${var.hostname}.${var.domain}"
HOSTEDZONEID="${var.dns_zone}"
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
  )

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "bastion" {
  name                = "${var.prefix}-bastion"
  min_size            = var.min_size
  max_size            = var.max_size
  default_cooldown    = 0
  vpc_zone_identifier = flatten(var.subnets)

  health_check_type         = "EC2"
  health_check_grace_period = 180

  launch_template {
    id      = aws_launch_template.bastion.id
    version = aws_launch_template.bastion.latest_version
  }

  enabled_metrics = [
    "GroupMinSize",
    "GroupMaxSize",
    "GroupDesiredCapacity",
    "GroupInServiceInstances",
    "GroupPendingInstances",
    "GroupStandbyInstances",
    "GroupTerminatingInstances",
    "GroupTotalInstances"
  ]

  lifecycle {
    create_before_destroy = true
  }

  tag {
    key                 = "Name"
    value               = "${var.prefix}-bastion"
    propagate_at_launch = true
  }
}

data "aws_ami" "amazon_linux_2023" {
  owners      = ["amazon"]
  most_recent = true

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }
}
