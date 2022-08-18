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