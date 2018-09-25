# CREATE IAM GROUPS

resource "aws_iam_group" "admins" {
  name = "${var.prefix}-admins"
}
