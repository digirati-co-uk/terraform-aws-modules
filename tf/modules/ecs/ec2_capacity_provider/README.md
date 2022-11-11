# ec2_capacity_provider

This module outputs the name of an [ECS Capacity Provider](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/cluster-capacity-providers.html) for attaching to a cluster and services within it.

As well as the capacity provider, it creates an auto scaling group and a launch template for the specified instance type and attaches the required IAM policies & roles.

If `assign_public_ips` is unset or false, then the VPC must contain either a NAT Gateway or VPC endpoints for the [required services](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/vpc-endpoints.html).
