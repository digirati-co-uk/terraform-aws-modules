locals {
  ulimits_keys        = keys(var.ulimits)
  sorted_ulimits_keys = sort(local.ulimits_keys)

  final_ulimits = [
    for key in local.sorted_ulimits_keys :
    {
      name      = key
      softLimit = tonumber(split(":", lookup(var.ulimits, key))[0])
      hardLimit = tonumber(split(":", lookup(var.ulimits, key))[1])
    }
  ]
}
