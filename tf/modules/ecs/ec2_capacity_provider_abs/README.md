# ec2_capacity_provider_abs

This module outputs the name of an [ECS Capacity Provider](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/cluster-capacity-providers.html) for attaching to a cluster and services within it.

As well as the capacity provider, it creates an auto scaling group and a launch template for the specified attribute-based instance types and attaches the required IAM policies & roles.

If `assign_public_ips` is unset or false, then the VPC must contain either a NAT Gateway or VPC endpoints for the [required services](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/vpc-endpoints.html).

> This differs from `ec2_capacity_provider` as it supports [attribute based instance selection](https://aws.amazon.com/blogs/aws/new-attribute-based-instance-type-selection-for-ec2-auto-scaling-and-ec2-fleet/) rather than specifying an instance type.