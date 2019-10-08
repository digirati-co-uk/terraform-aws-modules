locals {
  command_main         = "${jsonencode(var.command_main)}"
  mount_points_main    = "${jsonencode(var.mount_points_main)}"
  command_sidecar      = "${jsonencode(var.command_sidecar)}"
  mount_points_sidecar = "${jsonencode(var.mount_points_sidecar)}"
  volumes_from_main    = "${jsonencode(var.volumes_from_main)}"
  volumes_from_sidecar = "${jsonencode(var.volumes_from_sidecar)}"
  links_main           = "${jsonencode(var.links_main)}"
  links_sidecar        = "${jsonencode(var.links_sidecar)}"
  port_mappings        = "${var.port_mappings_length > 0 ? module.port_mappings.port_mappings_string : "[{\"hostPort\": ${var.host_port}, \"containerPort\": ${var.container_port}, \"protocol\": \"tcp\"}]"}"
  user_main            = "${length(var.user_main) > 0 ? "\"${var.user_main}\"" : "null"}"
  user_sidecar         = "${length(var.user_sidecar) > 0 ? "\"${var.user_sidecar}\"" : "null"}"
}

data "template_file" "definition" {
  template = "${file("${path.module}/files/task_definition.jsontemplate")}"

  vars {
    prefix                        = "${var.prefix}"
    log_group_name                = "${var.log_group_name}"
    log_group_region              = "${var.log_group_region}"
    log_prefix                    = "${var.log_prefix}"
    environment_variables_main    = "${module.env_vars_main.env_vars_string}"
    environment_variables_sidecar = "${module.env_vars_sidecar.env_vars_string}"
    container_name_main           = "${var.container_name_main}"
    container_name_sidecar        = "${var.container_name_sidecar}"
    container_port                = "${var.container_port}"
    docker_image_main             = "${var.docker_image_main}"
    docker_image_sidecar          = "${var.docker_image_sidecar}"
    cpu_reservation_main          = "${var.cpu_reservation_main}"
    cpu_reservation_sidecar       = "${var.cpu_reservation_sidecar}"
    memory_reservation_main       = "${var.memory_reservation_main}"
    memory_reservation_sidecar    = "${var.memory_reservation_sidecar}"
    command_main                  = "${local.command_main}"
    command_sidecar               = "${local.command_sidecar}"
    mount_points_main             = "${local.mount_points_main}"
    mount_points_sidecar          = "${local.mount_points_sidecar}"
    volumes_from_main             = "${local.volumes_from_main}"
    volumes_from_sidecar          = "${local.volumes_from_sidecar}"
    links_main                    = "${local.links_main}"
    links_sidecar                 = "${local.links_sidecar}"
    user_main                     = "${local.user_main}"
    user_sidecar                  = "${local.user_sidecar}"

    ulimits_main    = "${module.ulimits_main.ulimits_string}"
    ulimits_sidecar = "${module.ulimits_sidecar.ulimits_string}"

    port_mappings = "${local.port_mappings}"
  }
}

# produce a task definition as long as there are no mount points - services that need mount points will have to define their own resource outside of the module
resource "aws_ecs_task_definition" "task" {
  count                 = "${length(var.mount_points_main) == 0 && length(var.mount_points_sidecar) == 0  ? 1 : 0}"
  family                = "${var.family}"
  container_definitions = "${data.template_file.definition.rendered}"
  task_role_arn         = "${aws_iam_role.task.arn}"
}

module "env_vars_main" {
  source = "git::https://github.com/digirati-co-uk/terraform-aws-modules.git//tf/modules/services/tasks/environment-variables/"

  env_vars        = "${var.environment_variables_main}"
  env_vars_length = "${var.environment_variables_length_main}"
}

module "env_vars_sidecar" {
  source = "git::https://github.com/digirati-co-uk/terraform-aws-modules.git//tf/modules/services/tasks/environment-variables/"

  env_vars        = "${var.environment_variables_sidecar}"
  env_vars_length = "${var.environment_variables_length_sidecar}"
}

module "ulimits_main" {
  source = "git::https://github.com/digirati-co-uk/terraform-aws-modules.git//tf/modules/services/tasks/ulimits/"

  ulimits        = "${var.ulimits_main}"
  ulimits_length = "${var.ulimits_main_length}"
}

module "ulimits_sidecar" {
  source = "git::https://github.com/digirati-co-uk/terraform-aws-modules.git//tf/modules/services/tasks/ulimits/"

  ulimits        = "${var.ulimits_sidecar}"
  ulimits_length = "${var.ulimits_sidecar_length}"
}

module "port_mappings" {
  source = "git::https://github.com/digirati-co-uk/terraform-aws-modules.git//tf/modules/services/tasks/port-mappings/"

  port_mappings        = "${var.port_mappings}"
  port_mappings_length = "${var.port_mappings_length}"
}
