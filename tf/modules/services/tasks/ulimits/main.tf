locals {
  ulimits_keys = keys(local.ulimits)
  sorted_ulimits_keys = sort(local.ulimits_keys)

  vars = [
    for k in local.sorted_ulimits_keys : {
      name = k
      hardLimit = tonumber(split(":", lookup(local.ulimits, k))[0])
      softLimit = tonumber(split(":", lookup(local.ulimits, k))[1])
    }
  ]

  ulimits_string = jsonencode(local.vars)
}
