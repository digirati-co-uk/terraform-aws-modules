resource "aws_iam_account_alias" "alias" {
  count         = "${length(var.account_alias) == 0 ? 0 : 1}"
  account_alias = "${var.account_alias}"
}
