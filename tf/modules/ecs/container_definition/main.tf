locals {
  filtered_log_configuration    = { for k, v in var.log_configuration : k => v if v != null }
  filtered_container_definition = { for k, v in local.container_definition : k => v if v != null }

  container_definition = {
    essential = var.essential
    name      = var.name
    image     = var.image
    command   = var.command

    cpu    = var.cpu
    memory = var.memory

    memoryReservation = var.memory_reservation

    environment      = local.final_environment
    secrets          = local.final_secrets
    ulimits          = local.final_ulimits
    logConfiguration = local.filtered_log_configuration

    mountPoints  = var.mount_points
    portMappings = var.port_mappings
    healthCheck  = var.healthcheck
    user         = var.user
    dependsOn    = var.depends
    tags         = var.tags
    links        = var.links
    volumesFrom  = var.volumes_from

    systemControls         = var.system_controls
    readonlyRootFilesystem = var.read_only_filesystem
    repositoryCredentials  = var.repository_credentials
    resourceRequirements   = var.resource_requirements
  }
}
