locals {
  environment_keys        = keys(var.env_vars)
  sorted_environment_keys = sort(local.environment_keys)

  vars = [
    for k in local.sorted_environment_keys : {
      name  = k
      value = lookup(var.env_vars, k)
    }
  ]

  env_var_string = jsonencode(local.vars)
}
