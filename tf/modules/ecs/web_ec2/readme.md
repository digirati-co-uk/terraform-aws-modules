# Web EC2 Module

Creates an ECS Service with EC2 launch-type and associated target group (see `load-balancing/target` module.)

Use `additional_target_group_arns` to also register the service with additional target groups (e.g. on a second load balancer), using the same `container_name` and `container_port`. Note that a target group can only be associated with a single load balancer.
