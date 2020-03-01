resource "aws_efs_file_system" "data" {
  creation_token = "${var.cluster_name}"

  tags {
    "Name"        = "${var.cluster_name}"
    "Environment" = "${var.prefix}"
    "Project"     = "${var.project}"
    "ManagedBy"   = "Terraform"
  }
}

resource "aws_security_group" "mount_target" {
  name        = "${var.cluster_name}-mount-target"
  description = "EFS mount target access"
  vpc_id      = "${data.aws_vpc.main.id}"

  ingress {
    from_port       = 2049
    to_port         = 2049
    protocol        = "tcp"
    security_groups = ["${aws_launch_configuration.basic.security_groups}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    "Project" = "${var.project}"
  }
}

resource "aws_efs_mount_target" "data_mount_target" {
  count           = "${length(var.subnets)}"
  file_system_id  = "${aws_efs_file_system.data.id}"
  subnet_id       = "${element(var.subnets, count.index)}"
  security_groups = ["${aws_security_group.mount_target.id}"]
}
