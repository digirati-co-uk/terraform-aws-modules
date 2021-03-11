# Taken from https://github.com/wellcometrust/terraform-modules

data "template_file" "name_val_pair" {
  count = var.port_mappings_length

  template = "{\"hostPort\": $${key}, \"containerPort\": $${value1}, \"protocol\": \"tcp\"}"

  vars = {
    key    = element(keys(var.port_mappings), count.index)
    value1 = element(values(var.port_mappings), count.index)
  }
}

locals {
  port_mappings_string = "[${join(", ", "${data.template_file.name_val_pair.*.rendered}")}]"
}
