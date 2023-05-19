resource "aws_autoscaling_group" "asg" {
  name                = "${var.name}_asg"
  max_size            = var.max_instances
  default_cooldown    = var.scaling_action_cooldown
  vpc_zone_identifier = var.subnets

  min_size                  = var.min_instances
  health_check_type         = "EC2"
  health_check_grace_period = 180

  launch_template {
    id      = aws_launch_template.launch_template.id
    version = aws_launch_template.launch_template.latest_version
  }

  enabled_metrics = [
    "GroupMinSize",
    "GroupMaxSize",
    "GroupDesiredCapacity",
    "GroupInServiceInstances",
    "GroupPendingInstances",
    "GroupStandbyInstances",
    "GroupTerminatingInstances",
    "GroupTotalInstances"
  ]

  tag {
    key                 = "Name"
    value               = "${var.name}_instance"
    propagate_at_launch = true
  }

  tag {
    key                 = "AmazonECSManaged"
    propagate_at_launch = true
    value               = ""
  }
}
