# Borg cluster module

resource "aws_ecs_cluster" "borg" {
  name = var.cluster_name
}

resource "aws_iam_role" "borg" {
  name = var.cluster_name

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "borg_ec2" {
  role = aws_iam_role.borg.name

  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_policy" "borg_abilities" {
  name        = var.cluster_name
  description = "Cluster userdata abilities (route53, s3 access)"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Action": [
          "s3:GetObject",
          "s3:HeadObject"
        ],
        "Resource": "arn:aws:s3:::${var.bootstrap_objects_bucket}/*"
      },
      {
        "Effect": "Allow",
        "Action": [
          "s3:ListBucket"
        ],
        "Resource": "arn:aws:s3:::${var.bootstrap_objects_bucket}"
      },
      {
        "Effect": "Allow",
        "Action": [
          "route53:GetHostedZone",
          "route53:ListResourceRecordSets",
          "route53:ChangeResourceRecordSets",
          "route53:ChangeTagsForResource"
        ],
        "Resource": "*"
      }
    ]
  }
EOF
}

resource "aws_iam_role_policy_attachment" "borg_abilities" {
  role = aws_iam_role.borg.name

  policy_arn = aws_iam_policy.borg_abilities.arn
}

resource "aws_iam_instance_profile" "borg" {
  name = var.cluster_name
  role = aws_iam_role.borg.name
}

locals {
  makedirs = formatlist("mkdir -p ${var.mount_point_data_ebs}/scratch/%s", var.scratch_folders)

  dir_config = <<EOFDIRS

mkdir -p ${var.mount_point_data_ebs}/scratch
mkdir -p ${var.mount_point_data_ebs}/efs

ln -s ${var.mount_point_data_ebs}/scratch /scratch
ln -s ${var.mount_point_data_ebs}/efs /efs

${local.makedirs}

chmod -R 775 ${var.mount_point_data_ebs}/scratch
chmod -R 775 ${var.mount_point_data_ebs}/efs

EOFDIRS
}

resource "aws_launch_configuration" "borg" {
  name_prefix          = "${var.cluster_name}-"
  image_id             = var.ami
  instance_type        = var.instance_type
  iam_instance_profile = aws_iam_instance_profile.borg.name
  key_name             = var.key_name

  security_groups = [
    join("", aws_security_group.borg.*.id)
  ]

  user_data = <<EOF
#!/bin/bash

yum update -q -y

# install packages

yum install -q -y jq aws-cli amazon-efs-utils wget

# mount the EFS volume and add to fstab so it mounts at boot

mkdir -p ${var.mount_point_data}

echo "${aws_efs_file_system.data.id}:/ ${var.mount_point_data} efs defaults,_netdev 0 0" >> /etc/fstab

n=0
until [ $n -ge 5 ]
  do
    echo "trying EFS mount in 10 seconds..."
    sleep 10
    mount ${var.mount_point_data}
    if [ $? -eq 0 ]; then
      echo "EFS mounted"
      break
    else
      echo "EFS failed to mount"
      ((n += 1))
    fi
  done

# mount the EBS volume and add to fstab so it mounts at boot

mkdir -p ${var.mount_point_data_ebs}
mkfs -t ext4 /dev/xvdf
mount /dev/xvdf ${var.mount_point_data_ebs}
echo "/dev/xvdf ${var.mount_point_data_ebs} ext4 defaults,nofail" >> /etc/fstab

# make swap
fallocate -l ${var.swap_size_gb}G /swap
mkswap /swap
chmod 0600 /swap
swapon /swap
echo "/swap    swap   swap   defaults  0 0" >> /etc/fstab

${local.dir_config}

# restart docker so it can see newly mounted volumes
service docker restart

# daily cleanup for docker
cat > /etc/cron.daily/docker-cleanup.sh <<EOFCAT
#!/bin/sh
docker system prune -a -f
EOFCAT

chmod +x /etc/cron.daily/docker-cleanup.sh
${var.additional_config}
EOF

  root_block_device {
    volume_size           = var.root_size
    volume_type           = "gp2"
    delete_on_termination = true
  }

  # docker
  ebs_block_device {
    device_name           = "/dev/xvdcz"
    volume_size           = var.docker_size
    volume_type           = "gp2"
    delete_on_termination = true
  }

  # data-ebs
  ebs_block_device {
    device_name           = "/dev/xvdf"
    volume_size           = var.data_ebs_size
    volume_type           = "gp2"
    delete_on_termination = false
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "borg" {
  name                 = var.cluster_name
  launch_configuration = aws_launch_configuration.borg.name

  max_size            = var.max_size
  min_size            = var.min_size
  vpc_zone_identifier = flatten(var.subnets)

  default_cooldown = 0

  lifecycle {
    create_before_destroy = true
  }

  tag {
    key                 = "Name"
    value               = var.cluster_name
    propagate_at_launch = true
  }

  tag {
    key                 = "Project"
    value               = var.project
    propagate_at_launch = true
  }

  tag {
    key                 = "Terraform"
    value               = true
    propagate_at_launch = true
  }

  depends_on = [
    aws_efs_mount_target.data_mount_target
  ]
}
