# Change log

## v1.0 - ??

Terraform 0.11

## v2.0 - ??

Terraform 0.12

## v2.1 2020-09-24

Update `aws_alb_listener_rule` resources to use new `condition` syntax as this moved from warning to error.

```hcl
# from..
condition {
  field  = "host-header"
  values = ["my-hostname"]
}

# to..
condition {
  host_header {
    values = ["my-hostname"]
  }
}
```

## 2.2 2020-11-03

Update typo in `port_mappings` for services/tasks/quartet

## 2.3 2021-05-10

Introduce `ecs/container_definition` and `ecs/task_definition` modules. These will allow more granular control over container and task than is currently in `/services/tasks`.

## 3.0 2021-12-01

Rewrite VPC module. Allows greater control of what is created by having submodules. Avoid need to specify all CIDRs and only supporting 2 subnets.

Remove `basic` cluster and added `standard`. Standard has no config for samba, elastic-search or private dockerhub and allows folders created to be specified by caller.

Delete `logging` + `dns` module as they only created a single resource.

Update `services/tasks/` modules:
* Create "env-vars" module to replace "environment-variable", gradually phase out needing to specify environment-var length in calling modules.
* Update "ulimits" and "port-mappings" to no longer require length to be set.
* Allow "secret_environment_variables" to be specified for tasks. _note - execution tasks are not configured in these modules so this needs extra work_

## 3.1 2022-01-11

Fix how secret keys are calculated for secret_reference

## 3.2 2022-03-24

Remove last usages of legacy interpolation syntax

## 3.3 2022-08-18

Add `min_size` and `max_size` to bastion module. This will allow setting to 0 to have a default 'off' bastion host.

## 3.4 2022-10-28

Add `/ecs/ec2_capacity_provider`, `/ecs/web_fargate` and `/ecs/web_ec2` modules.

Added `/load-balancing/target` module use from above `/web_*` modules.

Allow 'hostname' to be specified in bastion module.

## 3.5 2022-10-31

Add `links` parameter to container_definition module

## 3.6 2022-10-31

`hostname` and `zone_id` are optional for ecs/web_* modules.

## 3.7 2022-11-02

Allow data volume to be specified for `/ecs/ec2_capacity_provider`.

Add `ephemeral_storage` to `/ecs/task_definition`.

## 3.8 2022-11-08

Add `/ecs/autoscaling/scheduled` module.

Removed `services/base/worker` and `services/base/web-basic` modules.

## 3.9 2022-11-10

Ignore changes to `desired_count` for web_fargate and web_ecs.

## 3.10 2022-12-06

Fix SQS module to use topic_arn for `aws:SourceArn` condition, rather than topic_name

## 3.11 2023-01-12

Update SQS module to allow setting of `raw_message_delivery` on SNS subscription.

## 3.12 2023-02-03

Remove "Project" tag from everywhere with exception of ASG creation. Expectation is that `default_tags` will be used to set project from calling modules.

Add "resourceRequirements" to ecs/container_definition.

## 3.13 2023-03-02

Add "ulimits" variable to ECS container_definition module. Provided as a map:

```
ulimits = {
  "name"   = "softLimit:hardLimit"
  "nofile" = "32768:65536"
}
```

## 3.14 2023-05-03

Add `/ecs/ec2_capacity_provider_abs` module for creating ECS capacity provider with attribute based instance selection.

## 3.15 2023-05-04

Allow `base` to be set for capacity provider strategy in web_ec2 ecs module.

## 3.16 2023-05-19

Alter device_names use for capacity providers. Latest AMI's used 1 volume (`/dev/xvda`) for both OS and Docker, rather than previous approach of Docker having a separate volume.

## 3.17 2023-05-19

Allow `min_size` to set for capacity provider ASG

## 3.18 2023-06-06

Add `/vpc/legacy` module. This was removed in `3.0` in favour of much more flexible vpc module. 

Re-adding to allow estates that already use it to leverage `default_tags` without TF always detecting changes.

## 3.19 2023-06-28

Output `instance_role_name` from `/ecs/ec2_capacity_provider*` modules - this will allow adding further permissions as required.

## 3.20 2023-07-28

Adding in a `filter_policy` variable to the `sqs` module that allows a filter policy to be set on an SNS subscription to a queue

## 3.21 2023-09-11

Updates to `bastion` module:
* Remove use of default SG
* Default to `t3a.micro` instance
* Default to Amazon Linux 2023 ami if not specified
* Update to use IMDSv2 for getting public IP
* Switch from launch-configuration to launch-template
* Output bastion role

Updates to `vpc` module:
* Remove deprecated syntax in `aws_eip`

## 3.22 2023-10-26

Update load-balancer module to output id of attached security group

## 3.23 2023-12-07

Update to add `filter_policy_scope` to sns

## 3.24 2023-12-20

Allow retention to be specified for DLQ in SQS module

## 3.25 2024-01-17

Update `wildcard-alb` module to optionall add `access_logs`.

## 3.26 2024-06-17

Allow stickiness to be specified for `ecs/web_ec2` and `load-balancing/target`

## 3.27 2024-06-18

Bugfix for above - correct variable name

## 3.28 2024-06-25

Add default_tags to ASG resources for `ecs/ec2_capacity_provider` and `ecs/ec2_capacity_provider_abs`, as per this [workaround](https://github.com/hashicorp/terraform-provider-aws/issues/32328#issuecomment-2107223882)

## 3.29 2024-06-28

Update stickiness to allow for choosing whether to use `lb_cookie` or `app_cookie` and extend to `ecs/web_fargate`

## 3.30 2024-07-09

Allow deployment min/max percent to be set for ECS services in `ecs/web_fargate` and `ecs/web_ec2`.

Allow load-balancing algorithm to be controlled in `load-balancing/target` (extended to `ecs/web_fargate` and `ecs/web_ec2`)

## 3.31 2024-07-17

Add `data/alb` and `data/cloudfront` modules.

## 3.32 2024-08-07

Fix issue in  `load-balancing/target`, `ecs/web_fargate` and `ecs/web_ec2` that prevented stickiness being removed.

## 3.33 2024-08-16

Add default_tags to ASG resources for `bastion`, same as was done for capacity-providers in v3.28