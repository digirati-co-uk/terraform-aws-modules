module "task_role" {
  source = "./iam_role"

  task_name = var.task_name
}

resource "aws_ecs_task_definition" "task" {
  family                = var.task_name
  container_definitions = jsonencode(var.container_definitions)

  task_role_arn      = module.task_role.task_role_arn
  execution_role_arn = module.task_role.task_execution_role_arn

  network_mode = var.network_mode

  requires_compatibilities = var.launch_types

  cpu    = var.cpu
  memory = var.memory

  dynamic "ephemeral_storage" {
    for_each = var.ephemeral_storage > 0 ? [{}] : []

    content {
      size_in_gib = var.ephemeral_storage
    }
  }

  # Unused here, but must be set to prevent churn
  tags = {}

  dynamic "volume" {
    for_each = var.volumes

    content {
      name      = volume.value["name"]
      host_path = volume.value["host_path"]
    }
  }

  dynamic "volume" {
    for_each = var.efs_volumes

    content {
      name = volume.value["name"]
      efs_volume_configuration {
        file_system_id = volume.value["file_system_id"]
        root_directory = volume.value["root_directory"]
      }
    }
  }

  dynamic "volume" {
    for_each = var.ebs_volumes

    content {
      name = volume.value["name"]

      dynamic "ebs_volume_configuration" {
        for_each = volume.value.ebs_volume_configuration != null ? [volume.value.ebs_volume_configuration] : []

        content {
          encrypted        = ebs_volume_configuration.value.encrypted
          iops             = ebs_volume_configuration.value.iops
          size_in_gib      = ebs_volume_configuration.value.size_in_gib
          snapshot_id      = ebs_volume_configuration.value.snapshot_id
          throughput       = ebs_volume_configuration.value.throughput
          volume_type      = ebs_volume_configuration.value.volume_type
          kms_key_id       = ebs_volume_configuration.value.kms_key_id
          file_system_type = ebs_volume_configuration.value.file_system_type
          role_arn         = ebs_volume_configuration.value.role_arn
        }
      }
    }
  }

  dynamic "placement_constraints" {
    for_each = var.placement_constraints

    content {
      type       = placement_constraints.value["type"]
      expression = placement_constraints.value["expression"]
    }
  }
}
