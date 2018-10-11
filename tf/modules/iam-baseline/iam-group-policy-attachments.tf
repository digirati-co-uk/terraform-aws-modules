# IAM GROUP POLICY ATTACHMENTS

resource "aws_iam_group_policy_attachment" "force_mfa_admins" {
  group      = "${aws_iam_group.admins.name}"
  policy_arn = "${aws_iam_policy.force_mfa.arn}"
}

data "aws_iam_policy" "administrator_access" {
  arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

resource "aws_iam_group_policy_attachment" "administrator_access" {
  group      = "${aws_iam_group.admins.name}"
  policy_arn = "${data.aws_iam_policy.administrator_access.arn}"
}
