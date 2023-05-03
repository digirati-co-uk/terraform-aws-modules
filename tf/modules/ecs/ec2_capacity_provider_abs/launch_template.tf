resource "aws_launch_template" "launch_template" {
  name                   = "${var.name}_launch_template"
  image_id               = var.ami_id == null ? data.aws_ami.ecs_optimized.id : var.ami_id
  vpc_security_group_ids = var.security_group_ids
  user_data              = base64encode(local.user_data)
  update_default_version = true
  key_name               = var.key_name

  dynamic "instance_requirements" {
    for_each = length(var.instance_requirements) > 0 ? [var.instance_requirements] : []
    content {

      dynamic "accelerator_count" {
        for_each = try([instance_requirements.value.accelerator_count], [])
        content {
          max = try(accelerator_count.value.max, null)
          min = try(accelerator_count.value.min, null)
        }
      }

      accelerator_manufacturers = try(instance_requirements.value.accelerator_manufacturers, [])
      accelerator_names         = try(instance_requirements.value.accelerator_names, [])

      dynamic "accelerator_total_memory_mib" {
        for_each = try([instance_requirements.value.accelerator_total_memory_mib], [])
        content {
          max = try(accelerator_total_memory_mib.value.max, null)
          min = try(accelerator_total_memory_mib.value.min, null)
        }
      }

      accelerator_types = try(instance_requirements.value.accelerator_types, [])
      bare_metal        = try(instance_requirements.value.bare_metal, null)

      dynamic "baseline_ebs_bandwidth_mbps" {
        for_each = try([instance_requirements.value.baseline_ebs_bandwidth_mbps], [])
        content {
          max = try(baseline_ebs_bandwidth_mbps.value.max, null)
          min = try(baseline_ebs_bandwidth_mbps.value.min, null)
        }
      }

      burstable_performance   = try(instance_requirements.value.burstable_performance, null)
      cpu_manufacturers       = try(instance_requirements.value.cpu_manufacturers, [])
      excluded_instance_types = try(instance_requirements.value.excluded_instance_types, [])
      instance_generations    = try(instance_requirements.value.instance_generations, [])
      local_storage           = try(instance_requirements.value.local_storage, null)
      local_storage_types     = try(instance_requirements.value.local_storage_types, [])

      dynamic "memory_gib_per_vcpu" {
        for_each = try([instance_requirements.value.memory_gib_per_vcpu], [])
        content {
          max = try(memory_gib_per_vcpu.value.max, null)
          min = try(memory_gib_per_vcpu.value.min, null)
        }
      }

      dynamic "memory_mib" {
        for_each = [instance_requirements.value.memory_mib]
        content {
          max = try(memory_mib.value.max, null)
          min = memory_mib.value.min
        }
      }

      dynamic "network_interface_count" {
        for_each = try([instance_requirements.value.network_interface_count], [])
        content {
          max = try(network_interface_count.value.max, null)
          min = try(network_interface_count.value.min, null)
        }
      }

      on_demand_max_price_percentage_over_lowest_price = try(instance_requirements.value.on_demand_max_price_percentage_over_lowest_price, null)
      require_hibernate_support                        = try(instance_requirements.value.require_hibernate_support, null)
      spot_max_price_percentage_over_lowest_price      = try(instance_requirements.value.spot_max_price_percentage_over_lowest_price, null)

      dynamic "total_local_storage_gb" {
        for_each = try([instance_requirements.value.total_local_storage_gb], [])
        content {
          max = try(total_local_storage_gb.value.max, null)
          min = try(total_local_storage_gb.value.min, null)
        }
      }

      dynamic "vcpu_count" {
        for_each = [instance_requirements.value.vcpu_count]
        content {
          max = try(vcpu_count.value.max, null)
          min = vcpu_count.value.min
        }
      }
    }
  }

  ebs_optimized = var.ebs_size_gb > 0

  dynamic "block_device_mappings" {
    for_each = var.ebs_size_gb > 0 ? [{}] : []

    content {
      // The instance volume used by Docker
      device_name = "/dev/xvdcz"

      ebs {
        volume_size           = var.ebs_size_gb
        volume_type           = var.ebs_volume_type
        delete_on_termination = true
      }
    }
  }

  dynamic "block_device_mappings" {
    for_each = var.data_size_gb > 0 ? [{}] : []

    content {
      // The instance volume used by Docker
      device_name = "/dev/xvdf"

      ebs {
        volume_size           = var.data_size_gb
        volume_type           = var.data_volume_type
        delete_on_termination = true
      }
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
  source = "../ec2_capacity_provider/iam"
  name   = var.name
}
