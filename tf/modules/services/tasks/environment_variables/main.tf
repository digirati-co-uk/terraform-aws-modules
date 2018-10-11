# Taken from https://github.com/wellcometrust/terraform-modules

data "template_file" "name_val_pair" {
  // According to hashicorp/terraform#17287 and hashicorp/terraform#14677 length can only
  // be calculated for not computed values. If a map or list contains computed values,
  // the whole map is considered as computed.
  //
  // This means the way we pass environment variables at the moment only works if there
  // are no computed values (i.e. outputs from modules or outputs
  // from terraform resource types).
  //
  // TODO compute count once those issues are closed
  count = "${var.env_vars_length}"

  template = "{\"name\": $${jsonencode(key)}, \"value\": $${jsonencode(value)}}"

  vars {
    key   = "${element(keys(var.env_vars), count.index)}"
    value = "${element(values(var.env_vars), count.index)}"
  }
}

locals {
  env_var_string = "[${join(", ", "${data.template_file.name_val_pair.*.rendered}")}]"
}
