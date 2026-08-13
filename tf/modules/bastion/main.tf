data "aws_default_tags" "default_tags" {}
data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

locals {
  asg_resources_to_tag = ["instance", "volume", "network-interface"]

  # Path the bastion persists its SSH host key to
  host_key_ssm_path = trimsuffix(coalesce(var.host_key_ssm_path, "/${var.prefix}/bastion/host-keys"), "/")
  host_key_param    = "${local.host_key_ssm_path}/ssh_host_ed25519_key"
  host_key_kms_arg  = var.host_key_kms_key_id == null ? "" : "--key-id ${var.host_key_kms_key_id}"

  # SSM parameter ARNs concatenate the leading "/" of the parameter name
  host_key_param_arns = [
    for name in [local.host_key_param, "${local.host_key_param}.pub"] :
    "arn:aws:ssm:${data.aws_region.current.region}:${data.aws_caller_identity.current.account_id}:parameter${name}"
  ]
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

  statement {
    actions = [
      "ssm:GetParameter",
      "ssm:PutParameter",
    ]

    resources = local.host_key_param_arns
  }

  statement {
    actions = [
      "kms:Encrypt",
      "kms:Decrypt",
    ]

    # Use "*" for the SSM managed key: alias isn't valid in a policy Resource, and the key itself
    # might not exist yet (created on first SecureString write) so its ARN can't be looked up here.
    # For convenience only, use host_key_kms_key_id to a CMK to get a real boundary here
    resources = var.host_key_kms_key_id == null ? ["*"] : [var.host_key_kms_key_id]

    dynamic "condition" {
      for_each = var.host_key_kms_key_id == null ? [1] : []
      content {
        test     = "StringEquals"
        variable = "kms:ViaService"
        values   = ["ssm.${data.aws_region.current.region}.amazonaws.com"]
      }
    }
  }
}

resource "aws_iam_policy" "bastion_abilities" {
  name        = "${var.prefix}-bastion-abilities"
  description = "Bastion userdata abilities (route53, SSH host key in SSM)"
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
  image_id      = var.ami
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

DOMAIN="${var.hostname}.${var.domain}"

# Persistent SSH host key.
KEYFILE=/etc/ssh/ssh_host_ed25519_key
PARAM="${local.host_key_param}"

# Only installs the stored key once it has been read back and proven usable, so a missing
# or corrupt parameter won't leave sshd with an unusable host key
restore_key() {
  aws ssm get-parameter --name "$PARAM" --with-decryption \
    --query Parameter.Value --output text > /tmp/hostkey 2>/dev/null || return 1
  [ -s /tmp/hostkey ] || return 1
  # trims any trailing newline the CLI added and puts back exactly the one sshd requires
  printf '%s\n' "$(cat /tmp/hostkey)" > /tmp/hostkey.norm
  chmod 600 /tmp/hostkey.norm
  ssh-keygen -y -f /tmp/hostkey.norm > /tmp/hostkey.pub 2>/dev/null || return 1
  install -m 600 -o root -g root /tmp/hostkey.norm $KEYFILE
  install -m 644 -o root -g root /tmp/hostkey.pub $KEYFILE.pub
}

generate_key() {
  rm -f $KEYFILE $KEYFILE.pub
  ssh-keygen -q -t ed25519 -N '' -C "$DOMAIN" -f $KEYFILE
}

if ! restore_key; then
  generate_key
  # deliberately no --overwrite: if another instance stored a key first we lose the race
  # and read theirs back
  if aws ssm put-parameter --name "$PARAM" --type SecureString --value "$(cat $KEYFILE)" ${local.host_key_kms_arg}; then
    aws ssm put-parameter --name "$PARAM.pub" --type String --value "$(cat $KEYFILE.pub)" --overwrite
  else
    # lost the race, or SSM is unreachable - in the latter case keep the key just generated
    # so the host still comes up, it simply is not persistent
    restore_key || true
  fi
fi
rm -f /tmp/hostkey /tmp/hostkey.norm /tmp/hostkey.pub

# ed25519 is the only host key offered, so a stale RSA/ECDSA entry left in a user's
# known_hosts can never be negotiated and warn about a changed key
rm -f /etc/ssh/ssh_host_rsa_key* /etc/ssh/ssh_host_ecdsa_key*
mkdir -p /etc/ssh/sshd_config.d
printf 'HostKey /etc/ssh/ssh_host_ed25519_key\n' > /etc/ssh/sshd_config.d/50-bastion-hostkey.conf
systemctl restart sshd

# Route53 update. Runs after the host key is in place so that the hostname only starts
# resolving here once we are presenting the persistent key
TOKEN=$(curl -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600")
LOCALIP=$(curl -s "http://169.254.169.254/latest/meta-data/public-ipv4" -H "X-aws-ec2-metadata-token: $TOKEN")
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

resource "aws_autoscaling_schedule" "bastion_stop" {
  scheduled_action_name  = "${var.prefix}-bastion-stop"
  min_size               = 0
  max_size               = var.max_size
  desired_capacity       = 0
  autoscaling_group_name = aws_autoscaling_group.bastion.name
  recurrence             = var.cron_stop
}

resource "aws_autoscaling_schedule" "bastion_start" {
  scheduled_action_name  = "${var.prefix}-bastion-start"
  min_size               = var.min_size
  max_size               = var.max_size
  desired_capacity       = var.min_size
  autoscaling_group_name = aws_autoscaling_group.bastion.name
  recurrence             = var.cron_start
}
