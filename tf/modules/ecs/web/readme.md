# Web Module

This is based on the [terraform-aws-modules](https://github.com/digirati-co-uk/terraform-aws-modules/tree/master/tf/modules/services/base/web) `/services/base/web` module with updates to support Fargate launch types.

The differences being:

* Simplification of variables to avoid as many use cases (e.g. handling different http/https listeners and specifying certificate).
* Remove `iam_role` from ECS service - this is not required for `awsvpc` network mode as ECS service-linked role is automatically used.
* Add `network_configuration` to ECS service - required for `awsvpc` network mode.
* Add `launch_type = "FARGATE"` to ECS service.

> This can eventually be brought back to thet `terraform-aws-modules` repo but leaving here for ease of iterating on.