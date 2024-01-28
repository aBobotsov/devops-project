resource "aws_ecs_cluster" "ecs_cluster" {
  name = "ecs-cluster"
}

# Associate the FE autoscaling group with the cluster's capacity provider
resource "aws_ecs_capacity_provider" "ecs_capacity_provider_fe" {
  name = "fe-capacity-provider"

  auto_scaling_group_provider {
    auto_scaling_group_arn = aws_autoscaling_group.ecs_fe_asg.arn

    managed_scaling {
      maximum_scaling_step_size = 1000
      minimum_scaling_step_size = 1
      status                    = "ENABLED"
    }
  }
}

# Associate the BE autoscaling group with the cluster's capacity provider
resource "aws_ecs_capacity_provider" "ecs_capacity_provider_be" {
  name = "be-capacity-provider"

  auto_scaling_group_provider {
    auto_scaling_group_arn = aws_autoscaling_group.ecs_be_asg.arn

    managed_scaling {
      maximum_scaling_step_size = 1000
      minimum_scaling_step_size = 1
      status                    = "ENABLED"
    }
  }
}

# Bind autoscaling group capacity provider with ECS cluster
resource "aws_ecs_cluster_capacity_providers" "ecs_cluster_cap_provider" {
  cluster_name       = aws_ecs_cluster.ecs_cluster.name
  capacity_providers = [
    aws_ecs_capacity_provider.ecs_capacity_provider_fe.name,
    aws_ecs_capacity_provider.ecs_capacity_provider_be.name
  ]

  #  default_capacity_provider_strategy {
  #    base              = 1
  #    weight            = 100
  #    capacity_provider = aws_ecs_capacity_provider.ecs_capacity_provider_fe.name
  #  }
}
