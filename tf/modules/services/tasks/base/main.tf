locals {
  command       = "jsonencode(var.command)
  mount_points  = "jsonencode(var.mount_points)
  volumes_from  = "jsonencode(var.volumes_from)
  port_mappings = "var.port_mappings_length > 0 ? module.port_mappings.port_mappings_string : "[{\"hostPort\": ${var.host_port}, \"containerPort\": ${var.container_port}, \"protocol\": \"tcp\"}]"
  user          = "length(var.user) > 0 ? "\"${var.user}\"" : "null"
}

data "template_file" "definition" {
  template = "${var.container_port != "" ? file("${path.module}/files/task_definition.jsontemplate") : file("${path.module}/files/task_definition_worker.jsontemplate")}"

  vars = {
    prefix                = "${var.prefix}"
    log_group_name        = "${var.log_group_name}"
    log_group_region      = "${var.log_group_region}"
    log_prefix            = "${var.log_prefix}"
    environment_variables = "${module.env_vars.env_vars_string}"
    container_name        = "${var.container_name}"
    container_port        = "${var.container_port}"
    host_port             = "${var.host_port}"
    docker_image          = "${var.docker_image}"
    cpu_reservation       = "${var.cpu_reservation}"
    memory_reservation    = "${var.memory_reservation}"
    command               = "${local.command}"
    mount_points          = "${local.mount_points}"
    volumes_from          = "${local.volumes_from}"
    ulimits               = "${module.ulimits.ulimits_string}"
    port_mappings         = "${local.port_mappings}"
    user                  = "${local.user}"
  }
}

# produce a task definition as long as there are no mount points - services that need mount points will have to define their own resource outside of the module
resource "aws_ecs_task_definition" "task" {
  count                 = "length(var.mount_points) == 0 ? 1 : 0
  family                = "var.family
  container_definitions = "data.template_file.definition.rendered
  task_role_arn         = "aws_iam_role.task.arn
}

module "env_vars" {
  source = "../environment-variables/"

  env_vars        = "var.environment_variables
  env_vars_length = "var.environment_variables_length
}

module "ulimits" {
  source = "../ulimits/"

  ulimits        = "var.ulimits
  ulimits_length = "var.ulimits_length
}

module "port_mappings" {
  source = "../port-mappings/"

  port_mappings        = "var.port_mappings
  port_mappings_length = "var.port_mappings_length
}
