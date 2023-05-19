resource "aws_launch_template" "launch_template" {
  name                   = "${var.name}_launch_template"
  instance_type          = var.instance_type
  image_id               = var.ami_id == null ? data.aws_ami.ecs_optimized.id : var.ami_id
  vpc_security_group_ids = var.security_group_ids
  user_data              = base64encode(local.user_data)
  update_default_version = true
  key_name               = var.key_name

  ebs_optimized = var.root_size_gb > 0

  dynamic "block_device_mappings" {
    for_each = var.root_size_gb > 0 ? [{}] : []

    content {
      // Root volume used by OS + Docker
      device_name = "/dev/xvda"

      ebs {
        volume_size           = var.root_size_gb
        volume_type           = var.root_volume_type
        delete_on_termination = true
      }
    }
  }

  dynamic "block_device_mappings" {
    for_each = var.data_size_gb > 0 ? [{}] : []

    content {
      // additional volume 
      device_name = "/dev/xvdf"

      ebs {
        volume_size           = var.data_size_gb
        volume_type           = var.data_volume_type
        delete_on_termination = true
      }
    }
  }

  dynamic "instance_market_options" {
    for_each = var.use_spot_purchasing ? [{}] : []

    content {
      market_type = "spot"
    }
  }

  dynamic "network_interfaces" {
    for_each = var.assign_public_ips ? [{}] : []

    content {
      associate_public_ip_address = true
      security_groups             = var.security_group_ids
    }
  }

  iam_instance_profile {
    arn = module.iam.instance_profile_arn
  }
}

data "aws_ami" "ecs_optimized" {
  owners      = ["amazon"]
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-ecs-hvm-*-x86_64-ebs"]
  }
}

locals {
  set_cluster = "echo ECS_CLUSTER=${var.cluster_name} >> /etc/ecs/ecs.config"

  user_data = <<EOF
#!/bin/bash

${var.additional_user_data == "" ? local.set_cluster : format("%s\n%s", local.set_cluster, var.additional_user_data)}
EOF
}

module "iam" {
  source = "./iam"
  name   = var.name
}
