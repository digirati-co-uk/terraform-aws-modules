# Taken from https://github.com/wellcometrust/terraform-modules

data "template_file" "name_val_pair" {
  count = "${var.ulimits_length}"

  template = "{\"name\": $${jsonencode(key)}, \"hardLimit\": $${jsonencode(value1)}, \"softLimit\": $${jsonencode(value2)}}"

  vars {
    key    = "${element(keys(var.ulimits), count.index)}"
    value1 = "${element(split(":", element(values(var.ulimits), count.index)), 0)}"
    value2 = "${element(split(":", element(values(var.ulimits), count.index)), 1)}"
  }
}

locals {
  ulimits_string = "[${join(", ", "${data.template_file.name_val_pair.*.rendered}")}]"
}
