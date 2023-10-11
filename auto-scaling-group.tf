resource "aws_autoscaling_group" "cluster" {
  name                = "sample-asg"
  vpc_zone_identifier = tolist(data.aws_subnets.private.ids)

  max_size = var.auto_scaling_group.max_size
  min_size = var.auto_scaling_group.min_size

  capacity_rebalance    = true
  protect_from_scale_in = true
  max_instance_lifetime = var.auto_scaling_group.instance_lifetime

  mixed_instances_policy {
    launch_template {
      launch_template_specification {
        launch_template_id = aws_launch_template.br.id
        version            = "$Latest"
      }

      override {
        instance_requirements {
          memory_mib {
            min = var.auto_scaling_group.memory_min
            max = var.auto_scaling_group.memory_max
          }

          vcpu_count {
            min = var.auto_scaling_group.vcpu_min
            max = var.auto_scaling_group.vcpu_max
          }
        }
      }
    }

    instances_distribution {
      on_demand_base_capacity                  = var.auto_scaling_group.od_base_capacity
      on_demand_percentage_above_base_capacity = var.auto_scaling_group.od_percent_on_top
      on_demand_allocation_strategy            = "lowest-price"
      spot_allocation_strategy                 = var.auto_scaling_group.spot_strategy
    }
  }

  tag {
    key                 = "Name"
    value               = "sample-ec2"
    propagate_at_launch = true
  }

  tag {
    key                 = "AmazonECSManaged"
    value               = true
    propagate_at_launch = true
  }
}