data "template_file" "definition" {
  template = "${file("${path.module}/files/task_definition.jsontemplate")}"

  vars {
    prefix           = "${var.prefix}"
    log_group_name   = "${var.log_group_name}"
    log_group_region = "${var.log_group_region}"
    log_prefix       = "${var.log_prefix}"
    environment_vars = "${module.env_vars.env_vars_string}"
    docker_image     = "${var.docker_image}"
  }
}

module "env_vars" {
  source = "git::https://github.com/digirati-co-uk/terraform-aws-modules.git//tf/modules/services/tasks/environment_variables/"

  env_vars        = "${var.environment_variables}"
  env_vars_length = "${var.environment_variables_length}"
}
