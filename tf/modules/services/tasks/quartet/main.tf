locals {
  command_main           = jsonencode(var.command_main)
  mount_points_main      = jsonencode(var.mount_points_main)
  command_sidecar_1      = jsonencode(var.command_sidecar_1)
  command_sidecar_2      = jsonencode(var.command_sidecar_2)
  command_sidecar_3      = jsonencode(var.command_sidecar_3)
  mount_points_sidecar_1 = jsonencode(var.mount_points_sidecar_1)
  mount_points_sidecar_2 = jsonencode(var.mount_points_sidecar_2)
  mount_points_sidecar_3 = jsonencode(var.mount_points_sidecar_3)
  volumes_from_main      = jsonencode(var.volumes_from_main)
  volumes_from_sidecar_1 = jsonencode(var.volumes_from_sidecar_1)
  volumes_from_sidecar_2 = jsonencode(var.volumes_from_sidecar_2)
  volumes_from_sidecar_3 = jsonencode(var.volumes_from_sidecar_3)
  links_main             = jsonencode(var.links_main)
  links_sidecar_1        = jsonencode(var.links_sidecar_1)
  links_sidecar_2        = jsonencode(var.links_sidecar_2)
  links_sidecar_3        = jsonencode(var.links_sidecar_3)
  port_mappings          = var.port_mappings_length > 0 ? module.port_mappings.port_mappings_string : "[{\"hostPort\": ${var.host_port}, \"containerPort\": ${var.container_port}, \"protocol\": \"tcp\"}]"
  user_main              = length(var.user_main) > 0 ? "\"${var.user_main}\"" : "null"
  user_sidecar_1         = length(var.user_sidecar_1) > 0 ? "\"${var.user_sidecar_1}\"" : "null"
  user_sidecar_2         = length(var.user_sidecar_2) > 0 ? "\"${var.user_sidecar_2}\"" : "null"
  user_sidecar_3         = length(var.user_sidecar_3) > 0 ? "\"${var.user_sidecar_3}\"" : "null"
}

data "template_file" "definition" {
  template = file("${path.module}/files/task_definition.jsontemplate")

  vars = {
    prefix                          = var.prefix
    log_group_name                  = var.log_group_name
    log_group_region                = var.log_group_region
    log_prefix                      = var.log_prefix
    environment_variables_main      = module.env_vars_main.env_vars_string
    environment_variables_sidecar_1 = module.env_vars_sidecar_1.env_vars_string
    environment_variables_sidecar_2 = module.env_vars_sidecar_2.env_vars_string
    environment_variables_sidecar_3 = module.env_vars_sidecar_3.env_vars_string
    secrets_main                    = module.secrets_main.secrets_string
    secrets_sidecar_1               = module.secrets_sidecar_1.secrets_string
    secrets_sidecar_2               = module.secrets_sidecar_2.secrets_string
    secrets_sidecar_3               = module.secrets_sidecar_3.secrets_string
    container_name_main             = var.container_name_main
    container_name_sidecar_1        = var.container_name_sidecar_1
    container_name_sidecar_2        = var.container_name_sidecar_2
    container_name_sidecar_3        = var.container_name_sidecar_3
    container_port                  = var.container_port
    docker_image_main               = var.docker_image_main
    docker_image_sidecar_1          = var.docker_image_sidecar_1
    docker_image_sidecar_2          = var.docker_image_sidecar_2
    docker_image_sidecar_3          = var.docker_image_sidecar_3
    cpu_reservation_main            = var.cpu_reservation_main
    cpu_reservation_sidecar_1       = var.cpu_reservation_sidecar_1
    cpu_reservation_sidecar_2       = var.cpu_reservation_sidecar_2
    cpu_reservation_sidecar_3       = var.cpu_reservation_sidecar_3
    memory_reservation_main         = var.memory_reservation_main
    memory_reservation_sidecar_1    = var.memory_reservation_sidecar_1
    memory_reservation_sidecar_2    = var.memory_reservation_sidecar_2
    memory_reservation_sidecar_3    = var.memory_reservation_sidecar_3
    command_main                    = local.command_main
    command_sidecar_1               = local.command_sidecar_1
    command_sidecar_2               = local.command_sidecar_2
    command_sidecar_3               = local.command_sidecar_3
    mount_points_main               = local.mount_points_main
    mount_points_sidecar_1          = local.mount_points_sidecar_1
    mount_points_sidecar_2          = local.mount_points_sidecar_2
    mount_points_sidecar_3          = local.mount_points_sidecar_3
    volumes_from_main               = local.volumes_from_main
    volumes_from_sidecar_1          = local.volumes_from_sidecar_1
    volumes_from_sidecar_2          = local.volumes_from_sidecar_2
    volumes_from_sidecar_3          = local.volumes_from_sidecar_3
    links_main                      = local.links_main
    links_sidecar_1                 = local.links_sidecar_1
    links_sidecar_2                 = local.links_sidecar_2
    links_sidecar_3                 = local.links_sidecar_3
    user_main                       = local.user_main
    user_sidecar_1                  = local.user_sidecar_1
    user_sidecar_2                  = local.user_sidecar_2
    user_sidecar_3                  = local.user_sidecar_3

    ulimits_main      = module.ulimits_main.ulimits_string
    ulimits_sidecar_1 = module.ulimits_sidecar_1.ulimits_string
    ulimits_sidecar_2 = module.ulimits_sidecar_2.ulimits_string
    ulimits_sidecar_3 = module.ulimits_sidecar_3.ulimits_string

    port_mappings = local.port_mappings
  }
}

# produce a task definition as long as there are no mount points - services that need mount points will have to define their own resource outside of the module
resource "aws_ecs_task_definition" "task" {
  count                 = length(var.mount_points_main) == 0 && length(var.mount_points_sidecar_1) == 0 && length(var.mount_points_sidecar_2) == 0 && length(var.mount_points_sidecar_3) == 0  ? 1 : 0
  family                = var.family
  container_definitions = data.template_file.definition.rendered
  task_role_arn         = aws_iam_role.task.arn
}

module "env_vars_main" {
  source = "../env-vars/"

  env_vars = var.environment_variables_main
}

module "env_vars_sidecar_1" {
  source = "../env-vars/"

  env_vars = var.environment_variables_sidecar_1
}

module "env_vars_sidecar_2" {
  source = "../env-vars/"

  env_vars = var.environment_variables_sidecar_2
}

module "env_vars_sidecar_3" {
  source = "../env-vars/"

  env_vars = var.environment_variables_sidecar_3
}

module "ulimits_main" {
  source = "../ulimits/"

  ulimits = var.ulimits_main
}

module "ulimits_sidecar_1" {
  source = "../ulimits/"

  ulimits = var.ulimits_sidecar_1
}

module "ulimits_sidecar_2" {
  source = "../ulimits/"

  ulimits = var.ulimits_sidecar_2
}

module "ulimits_sidecar_3" {
  source = "../ulimits/"

  ulimits = var.ulimits_sidecar_3
}

module "port_mappings" {
  source = "../port-mappings/"

  port_mappings        = var.port_mappings
  port_mappings_length = var.port_mappings_length
}

module "secrets_main" {
  source = "../secrets"

  role_name = aws_iam_role.task.name
  secrets   = var.secret_environment_variables_main
}

module "secrets_sidecar_1" {
  source = "../secrets"

  role_name = aws_iam_role.task.name
  secrets   = var.secret_environment_variables_sidecar_1
}

module "secrets_sidecar_2" {
  source = "../secrets"

  role_name = aws_iam_role.task.name
  secrets   = var.secret_environment_variables_sidecar_2
}

module "secrets_sidecar_3" {
  source = "../secrets"

  role_name = aws_iam_role.task.name
  secrets   = var.secret_environment_variables_sidecar_3
}