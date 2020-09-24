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
  host-header {
    values = ["my-hostname"]
  }
}
```