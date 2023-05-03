resource "aws_autoscaling_group" "asg" {
  name                = "${var.name}_asg"
  max_size            = var.max_instances
  default_cooldown    = var.scaling_action_cooldown
  vpc_zone_identifier = var.subnets

  min_size                  = 0
  health_check_type         = "EC2"
  health_check_grace_period = 180

  dynamic "mixed_instances_policy" {
    for_each = [var.mixed_instances_policy]
    content {
      dynamic "instances_distribution" {
        for_each = try([mixed_instances_policy.value.instances_distribution], [])
        content {
          on_demand_allocation_strategy            = try(instances_distribution.value.on_demand_allocation_strategy, null)
          on_demand_base_capacity                  = try(instances_distribution.value.on_demand_base_capacity, null)
          on_demand_percentage_above_base_capacity = try(instances_distribution.value.on_demand_percentage_above_base_capacity, null)
          spot_allocation_strategy                 = try(instances_distribution.value.spot_allocation_strategy, null)
          spot_instance_pools                      = try(instances_distribution.value.spot_instance_pools, null)
          spot_max_price                           = try(instances_distribution.value.spot_max_price, null)
        }
      }

      launch_template {
        launch_template_specification {
          launch_template_id = aws_launch_template.launch_template.id
          version            = aws_launch_template.launch_template.latest_version
        }

        dynamic "override" {
          for_each = try(mixed_instances_policy.value.override, [])

          content {
            dynamic "instance_requirements" {
              for_each = try([override.value.instance_requirements], [])

              content {
                dynamic "accelerator_count" {
                  for_each = try([instance_requirements.value.accelerator_count], [])

                  content {
                    max = try(accelerator_count.value.max, null)
                    min = try(accelerator_count.value.min, null)
                  }
                }

                accelerator_manufacturers = try(instance_requirements.value.accelerator_manufacturers, null)
                accelerator_names         = try(instance_requirements.value.accelerator_names, null)

                dynamic "accelerator_total_memory_mib" {
                  for_each = try([instance_requirements.value.accelerator_total_memory_mib], [])

                  content {
                    max = try(accelerator_total_memory_mib.value.max, null)
                    min = try(accelerator_total_memory_mib.value.min, null)
                  }
                }

                accelerator_types      = try(instance_requirements.value.accelerator_types, null)
                allowed_instance_types = try(instance_requirements.value.allowed_instance_types, null)
                bare_metal             = try(instance_requirements.value.bare_metal, null)

                dynamic "baseline_ebs_bandwidth_mbps" {
                  for_each = try([instance_requirements.value.baseline_ebs_bandwidth_mbps], [])

                  content {
                    max = try(baseline_ebs_bandwidth_mbps.value.max, null)
                    min = try(baseline_ebs_bandwidth_mbps.value.min, null)
                  }
                }

                burstable_performance   = try(instance_requirements.value.burstable_performance, null)
                cpu_manufacturers       = try(instance_requirements.value.cpu_manufacturers, null)
                excluded_instance_types = try(instance_requirements.value.excluded_instance_types, null)
                instance_generations    = try(instance_requirements.value.instance_generations, null)
                local_storage           = try(instance_requirements.value.local_storage, null)
                local_storage_types     = try(instance_requirements.value.local_storage_types, null)

                dynamic "memory_gib_per_vcpu" {
                  for_each = try([instance_requirements.value.memory_gib_per_vcpu], [])

                  content {
                    max = try(memory_gib_per_vcpu.value.max, null)
                    min = try(memory_gib_per_vcpu.value.min, null)
                  }
                }

                dynamic "memory_mib" {
                  for_each = try([instance_requirements.value.memory_mib], [])

                  content {
                    max = try(memory_mib.value.max, null)
                    min = try(memory_mib.value.min, null)
                  }
                }

                dynamic "network_bandwidth_gbps" {
                  for_each = try([instance_requirements.value.network_bandwidth_gbps], [])

                  content {
                    max = try(network_bandwidth_gbps.value.max, null)
                    min = try(network_bandwidth_gbps.value.min, null)
                  }
                }

                dynamic "network_interface_count" {
                  for_each = try([instance_requirements.value.network_interface_count], [])

                  content {
                    max = try(network_interface_count.value.max, null)
                    min = try(network_interface_count.value.min, null)
                  }
                }

                on_demand_max_price_percentage_over_lowest_price = try(instance_requirements.value.on_demand_max_price_percentage_over_lowest_price, null)
                require_hibernate_support                        = try(instance_requirements.value.require_hibernate_support, null)
                spot_max_price_percentage_over_lowest_price      = try(instance_requirements.value.spot_max_price_percentage_over_lowest_price, null)

                dynamic "total_local_storage_gb" {
                  for_each = try([instance_requirements.value.total_local_storage_gb], [])

                  content {
                    max = try(total_local_storage_gb.value.max, null)
                    min = try(total_local_storage_gb.value.min, null)
                  }
                }

                dynamic "vcpu_count" {
                  for_each = try([instance_requirements.value.vcpu_count], [])

                  content {
                    max = try(vcpu_count.value.max, null)
                    min = try(vcpu_count.value.min, null)
                  }
                }
              }
            }

            instance_type = try(override.value.instance_type, null)

            dynamic "launch_template_specification" {
              for_each = try([override.value.launch_template_specification], [])

              content {
                launch_template_id = try(launch_template_specification.value.launch_template_id, null)
              }
            }

            weighted_capacity = try(override.value.weighted_capacity, null)
          }
        }
      }
    }
  }

  enabled_metrics = [
    "GroupMinSize",
    "GroupMaxSize",
    "GroupDesiredCapacity",
    "GroupInServiceInstances",
    "GroupPendingInstances",
    "GroupStandbyInstances",
    "GroupTerminatingInstances",
    "GroupTotalInstances"
  ]

  tag {
    key                 = "Name"
    value               = "${var.name}_instance"
    propagate_at_launch = true
  }

  tag {
    key                 = "AmazonECSManaged"
    propagate_at_launch = true
    value               = ""
  }
}
